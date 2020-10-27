# Agreement

Agreement is about matching each part of a sentence to the expected gramatical category. Although English is not hugely complicated when it comes to inflection and declension rules, there are a moderate number of categories which have very specific requirements. For example, we have to make sure that subjects agree with verbs and pronouns agree with antecedents.

In this guide, we will look at how different features of Calyx can be used to support adaptive and flexible sentence generation while correctly handling agreement.

The following categories should be trivially obvious to anyone fluent in English, but it’s worth establishing these rules explicitly as grammatical agreement has a tendency to confound simple methods of text generation. Like many problems in computing, the first step is identifying and labelling the precise structures we need to deal with.

## Person

When the subject of a sentence varies by person, the verb must follow:

- I am
- You are
- He/She is
- They are

## Gender

When the antecedent of a sentence has a defined or implied gender, any following pronouns must match that gender:

- Catra raises her arm
- Bow raises his arm
- Double Trouble raises their arm
- A Horde-Bot raises its arm

## Number

When the subject of a sentence varies between singular and plural forms

Determiners also have their own specific singular and plural forms:

- That robot
- Those robots
