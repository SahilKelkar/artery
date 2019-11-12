	#ifndef INETRADIODRIVER_H_PJFDM4JW
#define INETRADIODRIVER_H_PJFDM4JW

#include <artery/nic/RadioDriverBase.h>
#include <omnetpp/clistener.h>


// forward declaration
namespace inet {
class EtherMac;

} // namespace inet

namespace artery
{

class InetRadioDriver : public RadioDriverBase, public omnetpp::cListener
{
    public:
        int numInitStages() const override;
        void initialize(int stage) override;
        void handleMessage(omnetpp::cMessage*) override;

    protected:
        void receiveSignal(omnetpp::cComponent*, omnetpp::simsignal_t, double, omnetpp::cObject*) override;
        void handleDataIndication(omnetpp::cMessage*);
        void handleDataRequest(omnetpp::cMessage*) override;

    private:
        inet::EtherMac* mLinkLayer = nullptr;
};

} // namespace artery

#endif /* INETRADIODRIVER_H_PJFDM4JW */

