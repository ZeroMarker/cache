//Copyright (c) 2001 TrakHealth Pty Limited. ALL RIGHTS RESERVED.


function BodyLoadHandler() {
	var obj=document.getElementById("RBApSchIrreg");
	if (obj) obj.onclick=IrregClickHandler;
	var obj=document.getElementById("RBApSchNoApp");
	if (obj) obj.onblur=IntegerCheck;
	var obj=document.getElementById("RBApSchFreqNum");
	if (obj) obj.onblur=IntegerCheck;
	var obj=document.getElementById("RBApSchFreq");
	if (obj) obj.onblur=FreqCheck;
	var obj=document.getElementById("RBApSchDel");
	if (obj) obj.onclick=DeleteClickHandler;
	var obj=document.getElementById("RBApSchGen");
	if (obj) obj.onclick=GenerateClickHandler;
	var obj=document.getElementById("ID");
	if ((obj)&&(obj.value=="")) {
		var del=document.getElementById("RBApSchDel");
		if (del) del.disabled=true;
		var gen=document.getElementById("RBApSchGen");
		if (gen) gen.disabled=true;
	}
}

function IrregClickHandler() {
	var freq=document.getElementById("RBApSchFreq");
	var freqlu=document.getElementById("ld2337iRBApSchFreq");
	var freqnum=document.getElementById("RBApSchFreqNum");
	var gen=document.getElementById("RBApSchGen");
	if ((freq)&&(freqnum)&&(gen)) {
		if (this.checked==true) {
			freq.value="";
			freq.disabled=true;
			freq.className='disabledField';
			freqlu.disabled=true;
			freqnum.value="";
			freqnum.disabled=true;
			freqnum.className='disabledField';
			gen.disabled=false;
		} else {
			freq.disabled=false;
			freq.className='';
			freqlu.disabled=false;
			freqnum.disabled=false;
			freqnum.className='';
			gen.disabled=true;
		}
	}
}

function IntegerCheck() {
	var obj=document.getElementById("RBApSchFreq");
	var gen=document.getElementById("RBApSchGen");
	if (this.value!="") {
		if (this.value.length>2) {
			this.className='clsInvalid';
			return false
		}
		if ((obj)&&(obj.value!="")) {
			if (gen) gen.disabled=false
		}
	} else {
		if (gen) gen.disabled=true
	}
}

function FreqCheck() {
	var obj=document.getElementById("RBApSchFreqNum");
	var gen=document.getElementById("RBApSchGen");
	if (this.className='clsInvalid') return false;
	if (this.value!="") {
		if ((obj)&&(obj.value!="")) {
			if (gen) gen.disabled=false
		}
	} else {
		if (gen) gen.disabled=true
	}
}

function DeleteClickHandler() {
	if (this.disabled==true) return false;
	if (!confirm(t["deleteSchema"])) {
		return false;
	}
	return RBApSchDel_click();
}

function GenerateClickHandler() {
	if (this.disabled==true) return false;
	return RBApSchGen_click();
}

document.body.onload = BodyLoadHandler;