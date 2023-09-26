function ColorTblColumn(){
	var tbl=document.getElementById("tDHCPEPreItemNum");	
	var row=tbl.rows.length;
	row=row-1;
	var objPreWNum,objPreNum,objHadPreNum,objItemName;
	var PreWNum=""
	for (var j=1;j<row+1;j++) {
		
		
		var objPreWNum=document.getElementById('TPreWNumz'+j);
		if(objPreWNum){	
		var objPreWNumST=objPreWNum.parentElement;
		var PreWNum=objPreWNum.innerText;
		}
		var objPreNum=document.getElementById('TPreNumz'+j);
		if(objPreNum) {
			var PreNum=objPreNum.innerText;
			var objPreNumST=objPreNum.parentElement;
			}
		var objHadPreNum=document.getElementById('THadPreNumz'+j);
		if(objHadPreNum) {
			var HadPreNum=objHadPreNum.innerText;
			var objHadPreNumST=objHadPreNum.parentElement;
			}
		

	    var objItemName=document.getElementById('TItemNamez'+j);
		if(objItemName){
			var objItemNameST=objItemName.parentElement;
			var ItemName=objItemName.innerText;
			
		}
		
		if(PreWNum==" "){var PreWNum=0;}
	     var PreWNum=parseInt(PreWNum)
	     var HadPreNum=parseInt(HadPreNum)	     
	     var PreNum=parseInt(PreNum)
	     
		if (HadPreNum>=PreWNum) {
			objPreWNumST.bgColor="#FFFF00";
			objPreNumST.bgColor="#FFFF00";
			objHadPreNumST.bgColor="#FFFF00";
			objItemNameST.bgColor="#FFFF00";
		}
		if (HadPreNum>=PreNum) {
			
			objPreWNumST.bgColor="#FF00FF";
			objPreNumST.bgColor="#FF00FF";
			objHadPreNumST.bgColor="#FF00FF";
			objItemNameST.bgColor="#FF00FF";
			
		}
		
	}
}
function Ini()
{
	ColorTblColumn()
}
document.body.onload = Ini;