var SelectedRow=0;

document.body.onload = BodyLoadHandler;
function BodyLoadHandler() {
	var objtbl=document.getElementById('tDHCAdmOrder_Tree');
	if (objtbl) objtbl.onclick=DHCAdmOrderTblClickHandler;
}

function DHCAdmOrderTblClickHandler() {
	var eSrc=window.event.srcElement;
	var objtbl=document.getElementById('tDHCAdmOrder_Tree');
	var rows=objtbl.rows.length;
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var tblObj=getTable(rowObj);
	var selectrow=rowObj.rowIndex;
    if (!selectrow) return;
	var lastSelectedRow=selectedRowObj;
	
	var winf=EPR_getTopWindow();
	if ((lastSelectedRow.rowIndex==rowObj.rowIndex)&&(tblObj==getTable(lastSelectedRow))) {		
			rowObj.className=lastSelectedRow.PrevClassName;
			if ((lastSelectedRow.PrevBGColour)) {rowObj.style.backgroundColor=lastSelectedRow.PrevBGColour; lastSelectedRow.PrevBGColour='';}
			selectedRowObj=new Object();
			selectedRowObj.rowIndex="";
			//�����,���л������ʱ�������ʾ
			/*
			//Ҫ���ͷ��Ϣ�Ĳ�ȥ���
		    if (document.getElementById("EpisodeIDz"+rowObj.rowIndex)){
				EPR_ClearSelectedEpisode();
		    }
			*/
	}else{
		if ((rowObj.className!='clsRowDisabled')&&(rowObj.selectenabled!=0)) {
				rowObj.PrevClassName=rowObj.className;
				if ((rowObj.style.backgroundColor!='')) {rowObj.PrevBGColour=rowObj.style.backgroundColor; rowObj.style.backgroundColor='';}
				rowObj.className='clsRowSelected';
				lastSelectedRow.className=lastSelectedRow.PrevClassName;
				if (lastSelectedRow.PrevBGColour) lastSelectedRow.style.backgroundColor=lastSelectedRow.PrevBGColour;
				selectedRowObj=rowObj;
				var f=getFrmFromTbl(tblObj);
				
				var AdmLocDr=document.getElementById("TAdmLocDrz"+rowObj.rowIndex).value;
				if (AdmLocDr==session['LOGON.CTLOCID']){
					if (winf) {
						//ѡ������˵�ͷ��Ϣ�޹ص�����
						if (document.getElementById("EpisodeIDz"+rowObj.rowIndex)){
							var ret=confirm("�Ƿ񽫵�ǰ�����л�Ϊѡ���еľ���?")
							if (ret) {
								EPR_SelectEpisodeDetails(f,rowObj.rowIndex,winf,rowObj);
							    parent.refreshBar()
							}
						}
					}
				}
		}
	}
	
	return websys_cancel();
}
function SelectRowHandler()	{

	
}