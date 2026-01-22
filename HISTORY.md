# History of Fortune Programs

## Origins: Fortune Cookies and MOTD Programs

Fortune programs evolved from the intersection of two computing traditions: fortune cookie messages and Message of the Day (MOTD) systems.

### MOTD Systems and Login Messages

Starting in the late 1960s, timesharing systems commonly displayed messages to users upon login. These MOTD (Message of the Day) programs served administrative purposes - announcing system status, maintenance schedules, or policy updates. However, creative system administrators and users began adding humorous, inspirational, or thought-provoking content to these messages.

The fortune program concept emerged when users wanted more dynamic, personalized content than static MOTD messages. Rather than displaying the same message to everyone, fortune programs provided random selections from curated databases of quotes, jokes, and sayings.

### WAITS and the Fortune Cookie Concept

The Stanford AI Lab Timesharing System (WAITS), running on PDP-10 computers, originated the "fortune cookie" metaphor in computing. WAITS featured a collection of humorous and inspirational messages that users could access, similar to modern fortune programs.

The term "fortune cookie" entered computing jargon through WAITS and was later adopted by Unix systems. These early programs displayed random quotes, jokes, and sayings to users, often with a focus on computer science humor, science fiction references, and philosophical musings.

### TOPS-20 Fortune Program

TOPS-20 (DEC's operating system for PDP-10 computers, also known as TWENEX) had a fortune program that displayed random quotations and messages to users. This implementation represents one of the earliest documented fortune cookie programs outside of the WAITS system, confirming the spread of this concept through the DEC computing ecosystem.

## Who Wrote the First Fortune Programs?

### Unix Pioneers

The fortune program first appeared in Version 7 Unix (1979), released by Bell Labs. While the initial implementation isn't definitively attributed, the program became widely popular through BSD Unix distributions.

**Ken Arnold** wrote the most influential version of the fortune program for BSD systems in the early 1980s. His implementation became the standard for BSD-derived systems and was later ported to many other Unix variants.

## Unix Era Development (1979-1980s)

### Version 7 Unix (1979)

Version 7 Unix marked the program's formal introduction to the Unix world. This release represented a significant milestone in Unix history, introducing many utilities that became standard, including the Bourne shell, awk, and tar. The fortune program fit naturally into this ecosystem of useful, sometimes whimsical command-line tools.

### BSD Fortune (Early 1980s)

Ken Arnold's BSD implementation introduced several key features:
- Support for multiple fortune databases organized by theme
- Efficient random selection algorithms
- Integration with standard Unix text processing tools
- Extensive collections of fortunes covering computer science, science fiction, literature, and humor

## Fun Facts and Cultural Impact

### Overlap with MOTD Systems

Fortune programs frequently overlapped with MOTD functionality. Many users integrated fortune commands into their shell initialization files (`.profile`, `.login`) to display random messages at login, effectively creating personalized MOTD experiences. System administrators sometimes used fortune databases for official communications, blending administrative messages with entertaining content.

### Content Themes and Inside Jokes

BSD fortune databases became famous for their esoteric content:
- **Computer Science Humor**: References to buffer overflows, compiler errors, and programming language wars
- **Science Fiction**: Extensive Star Trek, Hitchhiker's Guide to the Galaxy, and Doctor Who references
- **Literary References**: Quotes from Ambrose Bierce, Dave Barry, and other humorists
- **Unix Culture**: Hacker folklore, system administration jokes, and technical puns

### The "Offensive" Fortune Database

A particularly notorious aspect of BSD fortune was the "offensive" fortune database - a separate collection of edgier, more provocative content. Users could opt into these fortunes with command-line flags, creating a system where computing environments could range from family-friendly to irreverently humorous.

### Integration with Computing Workflows

Fortune programs became deeply integrated into Unix workflows:
- **Login Scripts**: Automatic display upon shell startup
- **Logout Messages**: Farewell messages when ending sessions
- **Email Signatures**: Some users included fortune output in email signatures
- **System Administration**: Used in cron jobs and automated messages

### Lasting Legacy

Fortune programs remain popular in Unix-like systems today, with modern implementations including:
- Cross-platform ports for macOS, Linux, and BSD systems
- Integration with modern shells and terminal emulators
- Web-based fortune services and APIs
- Crowdsourced fortune databases maintained by communities

The enduring appeal lies in humanizing computing environments, providing brief moments of entertainment, inspiration, or reflection during technical work.

## References

- Wikipedia: Fortune (Unix)
- Jargon File entries on "fortune cookie"
- BSD fortune program documentation
- Historical Unix documentation from Bell Labs

---

*Fortune programs transformed static MOTD messages into dynamic, personalized experiences that became a beloved part of Unix culture.*