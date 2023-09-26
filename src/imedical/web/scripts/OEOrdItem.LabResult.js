// Copyright (c) 2002 TrakHealth Pty Limited. ALL RIGHTS RESERVED.

function ChkAbnormalResult() {
	var RefRange = document.getElementById("RefRange");
	RefRange=RefRange.innerText;
	RefRange=RefRange.split("-");
	RefRange[0]=parseFloat(RefRange[0]); RefRange[1]=parseFloat(RefRange[1]);
	var Value = document.getElementById("Value");
	if (Value) {
		var Result=parseFloat(Value.innerText);
		if (RefRange[0]=="") RefRange[0]="openlow";
		if (RefRange[1]=="") RefRange[1]="openhigh";
		var min=Math.min(RefRange[0],RefRange[1],Result);
		var max=Math.max(RefRange[0],RefRange[1],Result);
		var FlagCode=document.getElementById("OtherFlagCode");
		var FlagValue=document.getElementById("FlagValue");
		var clrBG=Value.currentStyle.backgroundColor;
		if ((FlagCode) && (FlagCode.value!="")) {
			if (FlagCode.value=="N") {
				Value.className="NormalResult"
				Value.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="L") {
				Value.className="LowResult"
				Value.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="H") {
				Value.className="HighResult"
				Value.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="LL") {
				Value.className="LowLowResult"
				Value.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="HH") {
				Value.className="HighHighResult"
				Value.style.backgroundColor=clrBG;
			} else if (FlagCode.value=="A") {
				Value.className="AbnormalResult"
				Value.style.backgroundColor=clrBG;
			}else if ((RefRange[0]=="openlow")||(RefRange[1]=="openhigh")) {
				if ((RefRange[0]=="openlow")&&(Result>RefRange[1])) {
					Value.style.color="Red";
				} else if ((RefRange[1]=="openhigh")&&(Result<RefRange[0])) {
					Value.style.color="Red";
				}
			} else if (((Result==min)||(Result==max))&&((Result!=RefRange[0])&&(Result!=RefRange[1]))) {
				Value.style.color="Red";
			}
		}else if ((FlagValue) && (FlagValue.value!="N") && (FlagValue.value!="")) {
			Value.style.color="Red";
		}
	}
}

ChkAbnormalResult();


