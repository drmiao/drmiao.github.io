System.security.allowDomain("*");

var bridge:CAS3Bridge = new CAS3Bridge(this,/*this.presentationURL,*/ this.commandConnectionName, this.eventConnectionName);
