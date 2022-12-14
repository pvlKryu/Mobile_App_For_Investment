import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FAQ'),
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: const [
              GFAccordion(
                title: 'Для чего нужен брокерский счет?',
                content:
                    'Брокерский счет — это специальный счет для торговли ценными бумагами и валютой на бирже. Он открывается у брокера — профессионального участника рынка ценных бумаг. Брокер выступает посредником между частным инвестором и биржей. По закону обычный человек не может совершать операции на бирже напрямую, поэтому он дает поручения брокеру, и уже тот от имени клиента покупает или продает финансовые активы. Для учета этих активов и нужен брокерский счет.',
              ),
              GFAccordion(
                title: 'Чем акции отличаются от облигаций?',
                content:
                    'Если говорить в целом, это просто разные виды ценных бумаг со своими особенностями и задачами.\nАкция — это в первую очередь доля в бизнесе. Покупая акцию, инвестор получает право на часть будущей прибыли компании в виде дивидендов. Также в случае успешной работы компании цена на ее акции может вырасти и принести инвестору дополнительный доход, если он решит продать эти акции. Но никаких четких гарантий стабильного потока дивидендов или значительного роста цены на акции никто дать не может.\nОблигация — это долговое обязательство. Компания берет у инвесторов деньги в долг, а взамен выдает им свои облигации как расписку с обещанием вернуть эти деньги за определенный срок. А пока компания возвращает долг, она платит инвесторам проценты — в виде так называемых купонов.\nВ случае с облигациями инвесторы могут заранее просчитать, когда и какой доход они получат. Однако этот доход обычно не сильно превышает ставки по банковским вкладам.',
              ),
              GFAccordion(
                title:
                    'Чем привилегированные акции отличаются от обыкновенных?',
                content:
                    'Привилегированные акции — это вид ценных бумаг, которые дают своим держателям дополнительные преимущества, но также накладывают и некоторые ограничения.\nБольше дивидендов — многие компании выплачивают более высокие дивиденды по привилегированным акциям. А если дивидендные выплаты урежут или полностью отменят, привилегированных акций это коснется в последнюю очередь или не коснется совсем.\nПриоритет при банкротстве — если компания обанкротилась, все, кто имеет право на долю в ее имуществе, «выстраиваются в очередь». Первыми идут кре­ди­то­ры и дер­жа­те­ли об­ли­га­ций, потом владельцы при­ви­ле­ги­ро­ван­ных акций и только после них — остальные акционеры.\nНет права голоса — в обмен на более высокие дивидендные выплаты держатели привилегированных акций добровольно отказываются от права голоса на общем собрании акционеров компании, кроме одного случая: когда их хотят лишить дивидендов.\nНа американском фондовом рынке существует еще одна модель градации акций: некоторые компании выпускают акции разных классов — A, B и С. Обычно в таких случаях акции класса A дают право на получение дивидендов, но не обладают правом голоса. Акции класса B и C предполагают и дивиденды, и право голоса. Различие между ними в том, что один голос по акции класса C равен 10 голосам по акции класса B. Но конкретные свойства акций разных классов у каждой компании могут быть своими. Чаще всего такое разделение акции делается для того, чтобы привлечь капитал со стороны частных инвесторов, но при этом сохранить право решающего голоса за менеджментом или основателями компании.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
