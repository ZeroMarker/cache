
var SelRow="";
function SelectRowHandler()	
{
	var eSrc = window.event.srcElement;	//�����¼���
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
	if (SelRow==selectrow){
		
	}else{
		SelRow=selectrow;
	}
}