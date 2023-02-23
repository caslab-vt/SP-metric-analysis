#include "SimpleAmqpClient/SimpleAmqpClient.h"
#include < iostream >

int main() {
  AmqpClient ::Channel::ptr_t channel = AmqpClient ::Channel::Create ( "localhost" );

  std ::string queue_name = "rpc_queue" ;
  channel -> DeclareQueue(queue_name, false , true , false , false );

  std ::string callback_queue_name = 
      channel -> DeclareQueue( "" , false , true , false , false );

  std ::string consumer_tag = 
      channel -> BasicConsume(callback_queue_name, "" , true , false , false , 1 );
   //The fourth parameter turns on the message confirmation (ack, you can use BasicAck to confirm the message later).

  while ( 1 ) {

    std ::cout << "please input n to calculate fib(n) : " ;
    std ::string message;
    std ::cin >> message;

    AmqpClient ::BasicMessage::ptr_t MESSAGE = 
        AmqpClient ::BasicMessage::Create (message);
    MESSAGE -> ReplyTo(callback_queue_name); //Set the replyto attribute. 
    MESSAGE -> CorrelationId( "12345678" );
     //Set the CorrelationId property, where a random number function can be used to generate a random id.

    channel -> BasicPublish( "" , queue_name, MESSAGE);

    AmqpClient ::Envelope::ptr_t envelope = 
        channel -> BasicConsumeMessage(consumer_tag);
    channel -> BasicAck(envelope);
     //message confirmation

    std ::string buffer = envelope -> Message() -> Body();

    std ::cout << "[x] got the result of fib(" << message << ")"
              << ": " << buffer << std ::endl ;
  }
}
