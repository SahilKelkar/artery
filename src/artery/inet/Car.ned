package artery.inet;

import artery.application.VehicleMiddleware;
import artery.networking.Vanetza;
import artery.nic.IRadioDriver;
import inet.node.inet.INetworkNode;
import inet.node.inet.StandardHostEx;
import inet.linklayer.contract.IWiredInterface;
import inet.mobility.contract.IMobility;
import inet.networklayer.common.InterfaceTable;
import inet.linklayer.contract.IEthernetInterface;
import inet.networklayer.configurator.ipv4.Ipv4NetworkConfigurator;

module Car extends PlainVehicle like INetworkNode
{
    parameters:
        @display("i=block/wrxtx;is=vs");
        @networkNode;
        @labels(node,ethernet-node);
        @statistic[posX](source="xCoord(mobilityPos(mobilityStateChanged))"; record=vector?);
        @statistic[posY](source="yCoord(mobilityPos(mobilityStateChanged))"; record=vector?);
        bool withAntennaMobility = default(false);
        //*.interfaceTableModule = default(absPath(".interfaceTableModule"));
        **.mobilityModule = default(absPath(".mobility"));
	int numRadios = default(1);

    gates:
        inout radioIn[numRadios] @directIn;
        inout pppg[] @labels(PPPFrame-conn);
        inout ethg[] @labels(EtherFrame-conn);

    submodules:
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=50,300");
        }

        wlan: StandardHostEx {
		parameters:
			@display(p=250,400,row,100;q=queue);
			mac.typename = EtherMac;
			encap.typename = EtherEncap;

    			mac.csmacdSupport = true;
    			mac.address = "auto";
    			mac.promiscuous= true;
    			mac.duplexMode = true;

    			mac.fcsMode= "declared";

    			*.interfaceTableModule = default(absPath(".interfaceTable"));

    			mac.txQueueLimit= 1000;
    			mac.queueModule= "";

    			//EtherEncap
    			numEthInterfaces = default(0);

    			*.macTableModule = default(absPath(".macTable"));

    			//encap.fcsMode = "computed";

    			//Ipv4
    			ipv4.crcMode= "declared";
			*.configurator.networkConfiguratorModule = "";

    			forwarding = false;
    			multicastForwarding = false;

    			*.routingTableModule = default(absPath(".ipv4.routingTable"));
    			*.arpModule = default(absPath(".arp"));
    			*.icmpModule = default(absPath(".icmp"));

    			//Tcp
    			tcp.crcMode = "declared";
    	}
       // antennaMobility: AntennaMobility if withAntennaMobility == true {
        //    parameters:
         //       @display("p=100,200");
         //       mobilityModule = "^.mobility";
       // }

         radioDriver[numRadios]: RadioDriver {
            parameters:
                @display("p=250,300,row,100");
                macModule = ".wlan[" + string(index) + "].eth[" +string(index) + "].mac";
        }

        vanetza: Vanetza {
            parameters:
                @display("p=250,200");
                *.middlewareModule = absPath("^.middleware");
                *.mobilityModule = absPath("^.mobility");
                *.radioDriverModule = absPath("^.radioDriver[0]");
                runtime.datetime = middleware.datetime;
        }

        middleware: VehicleMiddleware {
            parameters:
                @display("p=250,100");
                routerModule = ".vanetza.router";
                mobilityModule = ".mobility";
        }

    connections allowunconnected:

 	for i=0..sizeof(radioIn)-1 {
           //radioIn[i] --> { @display("m=s"); } --> wlan[i].ethg++;
	     radioIn[i] <--> wlan[i].ethg++;

            wlan[i].upperLayerOut --> radioDriver[i].lowerLayerIn;
            wlan[i].upperLayerIn <-- radioDriver[i].lowerLayerOut;
        }
          

        radioDriver[0].upperLayer <--> vanetza.radioDriverData;
        radioDriver[0].properties --> vanetza.radioDriverProperties;
}
