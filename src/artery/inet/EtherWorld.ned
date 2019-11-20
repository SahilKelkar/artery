package artery.inet;

import artery.storyboard.Storyboard;
import inet.environment.contract.IPhysicalEnvironment;
import inet.linklayer.contract.IEthernetInterface;
import inet.linklayer.ethernet.EthernetInterface;
import inet.physicallayer.ethernet.EtherPhy;
import inet.physicallayer.contract.packetlevel.IRadioMedium;
import inet.linklayer.ethernet.EtherEncap;
import traci.Manager;
import inet.linklayer.contract.IEtherMac;
import inet.linklayer.ethernet.EtherLlc;
import inet.common.MessageDispatcher;
import inet.networklayer.common.InterfaceTable;

network EtherWorld
{
    parameters:
        bool withStoryboard = default(false);
        bool withPhysicalEnvironment = default(false);
        int numRoadSideUnits = default(0);
        traci.mapper.vehicleType = default("artery.inet.Car");
        traci.nodes.vehicleSinkModule = default(".mobility");
        storyboard.middlewareModule = default(".middleware");
        EthernetMedium.interfaceTableModule = default(absPath(""));

        @display("bgb=928,454");
    gates:
        input upperLayerIn;
        output upperLayerOut;
	inout ethg @labels(EtherFrame-conn);
    submodules:
        traci: Manager {
            parameters:
                @display("p=20,20");
        }

        EthernetMedium: EtherSwitch {
                    @display("p=250,100");
                }
       physicalEnvironment: <default("PhysicalEnvironment")> like IPhysicalEnvironment if withPhysicalEnvironment {
            parameters:
                @display("p=100,20");
        }


        dp: MessageDispatcher {
            parameters:
                @display("p=400,145;b=300,5,,,,1");
        }

        storyboard: Storyboard if withStoryboard {
            parameters:
                @display("p=140,20");
        }
	
        
    connections :

        dp.out++ --> EthernetMedium.upperLayerIn;
        EthernetMedium.upperLayerOut --> dp.in++;
	ethg <--> EthernetMedium.phys;
        dp.out++ --> upperLayerOut;
        upperLayerIn --> dp.in++;
	
	
}
