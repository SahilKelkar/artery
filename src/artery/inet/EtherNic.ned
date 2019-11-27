package artery.inet;

import inet.node.inet.StandardHostEx;

module EtherNic extends StandardHostEx
{
    parameters:
        
        //EtherMac
        mac.typename = "EtherMac";
	encap.typename = "EtherEncap";

        mac.csmacdSupport = true;
        mac.address = "auto";
        mac.promiscuous= true;
        mac.duplexMode = true;

        mac.fcsMode= "declared";

        *.interfaceTableModule = default(absPath(interfaceTableModule));

        txQueueLimit= 1000;
        queueModule= "";
        
        //EtherEncap
        numEthInterfaces = default(0);

        *.macTableModule = default(absPath(".macTable"));
        
        //encap.fcsMode = "computed";

        //Ipv4
        ipv4.crcMode= "declared";

        forwarding = false;
        multicastForwarding = false;

        *.routingTableModule = default(absPath(".routingTable"));
        *.arpModule = default(absPath(".arp"));
        *.icmpModule = default(absPath(".icmp"));
        
        //Tcp
        tcp.crcMode = "declared";


      
        
}
