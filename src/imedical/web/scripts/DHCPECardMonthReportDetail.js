
var SelRow="";
function SelectRowHandler()	
{
	var eSrc = window.event.srcElement;	//触发事件的
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (SelRow==selectrow){
		
	}else{
		SelRow=selectrow;
	}
}