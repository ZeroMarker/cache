//CreatScheduleByWeekSchedule.js

document.body.onload = BodyLoadHandler;

function BodyLoadHandler() {
var Creat=document.getElementById("Create")
if(Creat) Creat.onclick=Creat_click;
}
function Creat_click(){
	var FromDate=document.getElementById("FromDate").value
	var ToDate=document.getElementById("ToDate").value
	var StartDate=document.getElementById("StartDate").value
	var EndDate=document.getElementById("EndDate").value
	var CopyByOneWeek=""
	var CopyByOneWeekObj=document.getElementById("CopyByOneWeek")
	if (CopyByOneWeekObj){
		CopyByOneWeek=CopyByOneWeekObj.checked
		}
	var CopySchedulesClass=document.getElementById("CopySchedulesClass")
	if (CopySchedulesClass){var encmeth=CopySchedulesClass.value}else{var encmeth=""}
	var ret=cspRunServerMethod(encmeth,FromDate,ToDate,StartDate,EndDate,CopyByOneWeek)
	if (ret!=0){
			alert("∏¥÷∆≈≈∞‡ ß∞‹"+ret.split("^")[1])
		return false
		}else{
			alert("∏¥÷∆≈≈∞‡≥…π¶,«ÎºÏ≤È!")
			}
	}