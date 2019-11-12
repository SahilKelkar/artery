package artery.inet;

import artery.application.VehicleMiddleware;
import artery.networking.Vanetza;
import artery.nic.IRadioDriver;
import inet.node.inet.INetworkNode;
import inet.linklayer.contract.IWiredInterface;
import inet.mobility.contract.IMobility;
import inet.networklayer.common.InterfaceTable;

module Car extends PlainVehicle like INetworkNode
{
    parameters:
        @display("i=block/wrxtx;is=vs");
        @networkNode;
        @labels(node,ethernet-node);
        @statistic[posX](source="xCoord(mobilityPos(mobilityStateChanged))"; record=vector?);
        @statistic[posY](source="yCoord(mobilityPos(mobilityStateChanged))"; record=vector?);
        bool withAntennaMobility = default(false);
        *.interfaceTableModule = default(absPath(".interfaceTable"));
        **.mobilityModule = default(absPath(".mobility"));
	int numRadios = default(1);

    gates:
        input radioIn[numRadios] @directIn;
        inout pppg[] @labels(PPPFrame-conn);
        inout ethg[] @labels(EtherFrame-conn);

    submodules:
        interfaceTable: InterfaceTable {
            parameters:
                @display("p=50,300");
        }

        wlan: <default("EtherNic")> like EthernetInterface {
            parameters:
                @display("p=250,400,row,100;q=queue");
                
        }

        antennaMobility: AntennaMobility if withAntennaMobility == true {
            parameters:
                @display("p=100,200");
                mobilityModule = "^.mobility";
        }

        radioDriver: RadioDriver {
            parameters:
                @display("p=250,300,row,100");
                macModule = ".wlan[0].mac";
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

    connections:
          
            wlan.upperLayerOut --> radioDriver.lowerLayerIn;
            wlan.upperLayerIn <-- radioDriver.lowerLayerOut;
       

        radioDriver.upperLayer <--> vanetza.radioDriverData;
        radioDriver.properties --> vanetza.radioDriverProperties;
}
