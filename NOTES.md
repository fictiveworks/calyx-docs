## logline.mjs

```js
import calyx from "calyx"

// protagonist + inciting incident + protagonist’s goal + central conflict.

const logline = calyx.grammar({
  "start": "When a {protagonist} {inciting_discovery}, {central_goal}.",
  "protagonist": [
    "{simple_adj} {protagonist_person}",
    "{$wayward_adj} {protagonist_person}"
  ],
  "simple_adj": ["simple", "curious", "naive"],
  "wayward_adj": ["wayward", "rebellious", "troubled", "down and out", "burned out"],
  "protagonist_person": [
    "farm kid",
    "teen",
    "archaeologist",
    "scientist",
    "ex-cop",
    "store clerk",
    "high school teacher"
  ],
  "inciting_discovery": [
    "discovers {@pronoun} {has_powers}",
    "witnesses {inciting_event}"
  ],
  "inciting_event": [
    "a {inciting_adj} {crime_event}",
    "a {inciting_adj} attempt to {solidarity_event}",
    "a {collective_event} turn {$threatening_adj}",
  ],
  "inciting_adj": [
    "strange",
    "mysterious",
    "chaotic",
    "botched",
    "thwarted"
  ],
  "crime_event": [
    "jewelry heist",
    "armed robbery",
    "drive-by shooting",
    "drug deal",
    "ram raid"
  ],
  "solidarity_event": [
    "form a union",
    "start a co-op",
    "fly an indigenous flag"
  ],
  "collective_event": [
    "protest march",
    "parade",
    "carnival",
    "concert",
    "sports match",
    "block party",
    "barbeque"
  ],
  "has_powers": [
    "has {powers}",
    "can do magic",
    "has {supernatural} {powers}"
  ],
  "powers": ["powers", "abilities"],
  "supernatural": ["magical", "supernatural", "superhuman"],
  "central_goal": [
    "{protagonist_does} to {liberate_verb} the {liberate_noun} from {main_threat}",
    "{protagonist_does} to put an end to {main_threat}"
  ],
  "liberate_verb": ["liberate", "free", "save", "rescue"],
  "liberate_noun": ["galaxy", "town", "city", "local mall", "planet", "borough"],
  "protagonist_does": [
    "{@pronoun} teams up {with_allies}",
    "{@pronoun} joins forces {with_allies}",
    "{@pronoun} forms an alliance {with_allies}",
    "{@pronoun} convinces {allies_group}"
  ],
  "pronoun": ["he", "she"],
  "with_allies": [
    "with other {allies}",
    "with {allies_group}"
  ],
  "allies_group": [
    "a {group} of {allies}",
    "a {group} of {$wayward_adj} {allies}",
  ],
  "group": ["group", "team", "squad", "collective", "posse"],
  "allies": [
    "rebel fighters",
    "misfits",
    "workers",
    "mercenaries"
  ],
  "main_threat": [
    "the {$threatening_adj} {forces} of {villain}",
    "the {$threatening_adj} {villain_corp}"
  ],
  "threatening_adj": ["sinister", "dangerous", "violent", "grim"],
  "forces": ["forces", "movements", "machinations"],
  "villain": [
    "a {villain_adj} {villain_individual}",
    "the {villain_corp}"
  ],
  "villain_individual": [
    "billionaire",
    "oligarch",
    "petro-baron",
    "spice-baron",
    "warlord",
    "crime boss"
  ],
  "villain_adj": ["capricious", "rogue", "malicious", "fascist", "delusional"],
  "villain_corp": [
    "Empire",
    "{evil_corp_prefix} {evil_corp} {evil_corp_suffix}",
    "{evil_corp} {evil_corp_suffix}",
    "{evil_corp_prefix} {evil_corp_suffix}"
  ],
  "evil_corp_prefix": ["Colonial", "Imperial", "Empire", "Dominion"],
  "evil_corp": ["Trading", "Trade", "Steamship", "Aerospace", "Petroleum", "Spice"],
  "evil_corp_suffix": ["Company", "Federation", "Corporation", "League"]
})

const result = logline.generate()

console.log(result.text)

```

## scigen.mjs

```js
//SCI_AB_A_START the SCI_ACT SCI_AB_A_END XXX
import calyx from "calyx"

const abstract = calyx.grammar({
  "start": "{sci_abstract}",

  "sci_abstract": "SCI_INTRO_A {sci_abstract_a} SCI_INTRO_THESIS",

  sci_abstract_a: "{sci_ab_a_start} the {sci_act} {sci_ab_a_end}",

  sci_ab_a_start: [
    "{sci_in_this_paper}, we {sci_prove_verb}",
    "in fact, few {sci_people} would disagree with",
    "given the current status of {sci_buzzword_adj} {sci_buzzword_noun}, {sci_people} {sci_adj_adv} desire",
    "after years of {sci_adj} research into {sci_thing_mod}, we {sci_prove_verb}"
  ],

  sci_ab_a_end: ["", "which embodies the {sci_adj} principles of SCI_FIELD"],

  // SCI_ACT+50	SCI_ACT_A SCI_THING
  // SCI_ACT		SCI_ACT_A SCI_THING that SCI_EFFECT
  // SCI_ACT_A	understanding of
  // SCI_ACT_A	SCI_ADJ unification of SCI_THING and
  // SCI_ACT_A+15	SCI_VERBION of

  sci_act: [
    "{sci_act_a} {sci_thing}",
    "{sci_act_a} {sci_thing} that {sci_effect}",
  ],
  sci_act_a: [
    "understanding of",
    "{sci_adj} unification of {sci_thing} and",
    "{sci_verbion} of"
  ],
  sci_effect: [
    "made {sci_verbing} and possibly {sci_verbing} {sci_thing} a reality",
    "would allow for further study into {sci_thing}",
    "paved the way for the {sci_act_a} {sci_thing}",
    "would make {sci_verbing} {sci_thing} a real possibility"
  ],
  sci_verbing: [
    "harnessing",
    "enabling",
    "exploring",
    "controlling",
    "developing",
    "refining",
    "architecting",
    "investigating",
    "improving",
    "analyzing",
    "constructing",
    "simulating",
    "evaluating",
    "emulating",
    "deploying",
    "synthesizing",
    "visualizing",
    "studying"
  ],

  sci_verbion: [
    "exploration",
    "development",
    "refinement",
    "investigation",
    "analysis",
    "improvement",
    "emulation",
    "simulation",
    "construction",
    "evaluation",
    "deployment",
    "synthesis",
    "visualization",
    "study"
  ],

  sci_in_this_paper: [
    "in this paper",
    "in this position paper",
    "in this work",
    "in our research",
    "here"
  ],

  sci_thing: ["{sci_thing_p}", "{sci_thing_s}"],

  sci_thing_s: [
    "courseware",
    "e-commerce",
    "IPv4",
    "IPv6",
    "IPv7",
    "the memory bus",
    "extreme programming",
    "the location-identity split",
    "Scheme",
    "DNS",
    "802.11b",
    "architecture",
    "the Internet",
    "consistent hashing",
    "the transistor",
    "the UNIVAC computer",
    "Boolean logic",
    "voice-over-IP",
    "the World Wide Web",
    "Moore's Law",
    "the Turing machine",
    "e-business",
    "context-free grammar",
    "evolutionary programming",
    "simulated annealing",
    "the partition table",
    "the lookaside buffer",
    "Internet QoS",
    "rasterization",
    "model checking",
    "lambda calculus",
    "scatter/gather I/O",
    "XML",
    "the Ethernet",
    "RAID",
    "telephony",
    "Smalltalk",
    "A* search",
    "reinforcement learning",
    "forward-error correction",
    "erasure coding",
    "redundancy",
    "replication",
    "congestion control",
    "the producer-consumer problem",
    "DHCP",
    "write-ahead logging",
    "cache coherence"
  ],

  sci_thing_p: [
    "DHTs",
    "robots",
    "agents",
    "Markov models",
    "SMPs",
    "kernels",
    "suffix trees",
    "spreadsheets",
    "operating systems",
    "systems",
    "interrupts",
    "Web services",
    "massive multiplayer online role-playing games",
    "Byzantine fault tolerance",
    "sensor networks",
    "online algorithms",
    "object-oriented languages",
    "information retrieval systems",
    "web browsers",
    "thin clients",
    "B-trees",
    "hierarchical databases",
    "randomized algorithms",
    "flip-flop gates",
    "neural networks",
    "von Neumann machines",
    "digital-to-analog converters",
    "journaling file systems",
    "expert systems",
    "active networks",
    "superpages",
    "superblocks",
    "POWER_OF_TWO bit architectures",
    "vacuum tubes",
    "I/O automata",
    "hash tables",
    "red-black trees",
    "linked lists",
    "fiber-optic cables",
    "802.11 mesh networks",
    "access points",
    "gigabit switches",
    "multi-processors",
    "compilers",
    "semaphores",
    "RPCs",
    "virtual machines",
    "Lamport clocks",
    "checksums",
    "link-level acknowledgements",
    "public-private key pairs",
    "symmetric encryption",
    "wide-area networks",
    "local-area networks",
    "write-back caches",
    "multicast SCI_SYSTEM_PL",
    "SCSI disks"
  ],

  sci_thing_mod: "{sci_thing} CITATION_SOMETIMES",

  sci_prove_verb: [
    "demonstrate",
    "argue",
    "prove",
    "show",
    "disprove",
    "validate",
    "verify",
    "confirm",
    "disconfirm"
  ],

  sci_people: [
    "leading analysts",
    "experts",
    "analysts",
    "scholars",
    "information theorists",
    "statisticians",
    "computational biologists",
    "system administrators",
    "electrical engineers",
    "cryptographers",
    "security experts",
    "systems engineers",
    "hackers worldwide",
    "biologists",
    "mathematicians",
    "physicists",
    "theorists",
    "researchers",
    "steganographers",
    "cyberinformaticians",
    "end-users",
    "futurists",
    "cyberneticists"
  ],

  sci_buzzword_adj: [
    "peer-to-peer",
    "game-theoretic",
    "knowledge-based",
    "relational",
    "compact",
    "ubiquitous",
    "linear-time",
    "‘fuzzy’",
    "embedded",
    "constant-time",
    "client-server",
    "efficient",
    "reliable",
    "replicated",
    "low-energy",
    "omniscient",
    "wireless",
    "modular",
    "autonomous",
    "introspective",
    "distributed",
    "flexible",
    "extensible",
    "amphibious",
    "metamorphic",
    "ambimorphic",
    "permutable",
    "adaptive",
    "self-learning",
    "trainable",
    "‘smart’",
    "classical",
    "atomic",
    "event-driven",
    "read-write",
    "encrypted",
    "highly-available",
    "secure",
    "interposable",
    "cacheable",
    "perfect",
    "electronic",
    "pervasive",
    "large-scale",
    "Bayesian",
    "multimodal",
    "authenticated",
    "interactive",
    "heterogeneous",
    "homogeneous",
    "collaborative",
    "concurrent",
    "probabilistic",
    "mobile",
    "wearable",
    "semantic",
    "real-time",
    "cooperative",
    "decentralized",
    "scalable",
    "certifiable",
    "robust",
    "signed",
    "virtual",
    "lossless",
    "psychoacoustic",
    "empathic",
    "optimal",
    "stable",
    "unstable",
    "symbiotic",
    "stochastic",
    "random",
    "pseudorandom"
  ],
  sci_buzzword_noun: [
    "technology",
    "communication",
    "algorithms",
    "theory",
    "methodologies",
    "information",
    "models",
    "archetypes",
    "configurations",
    "modalities",
    "symmetries",
    "epistemologies"
  ],

  sci_adj: [
    "important",
    "significant",
    "key",
    "unfortunate",
    "robust",
    "typical",
    "unproven",
    "confusing",
    "extensive",
    "appropriate",
    "confirmed",
    "theoretical",
    "technical",
    "structured",
    "natural",
    "essential",
    "private",
    "intuitive",
    "practical",
    "compelling"
  ],
  sci_adj_adv: [
    "particularly",
    "dubiously",
    "daringly",
    "shockingly",
    "daringly",
    "famously",
    "predictably",
    "clearly",
    "obviously",
    "urgently",
    "compellingly"
  ]
})

console.log(abstract.generate().toString())

```

## weighted.mjs

```js
import calyx from "calyx"

const manu = calyx.grammar({
  backyard: ["house sparrow", "blackbird", "starling"],
  coastal: ["black-backed gull", "red-billed gull"],
  forest: ["tūī", "korimako", "pīwakawaka"]
})

const result = manu.generate({
  start: {
    "{backyard}": 3,
    "{coastal}": 2,
    "{forest}": 1
  }
})

console.log(result.text)
```

## Look it up in the dictionary

Handling this mapping from one to the other is a recurring problem when making large grammars, so Calyx provides a shortcut for adding paired lookups in the grammar directly.

Here, the `{@animal>posessive}` shortcut inflects the output of the memoized `animal` rule using the lookup table declared in `posessive`.

```js
calyx.grammar({
  start: "{@animal} {verb} {@animal>posessive} {appendage}",
  animal: ["Snowball", "Santa’s Little Helper"]
  posessive: {
    "Snowball": "her",
    "Santa’s Little Helper": "his"
  },
  verb: ["chases", "licks", "bites"],
  appendage: ["tail", "paw"]
})
```

Using Calyx’s syntax features like this results in a more abstract and compact grammar, with the tradeoff of having to get used to the custom syntax for map lookups.