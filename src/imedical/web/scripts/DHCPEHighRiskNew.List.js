document.body.onload = BodyLoadHandler;

var SelRow="";

function BodyLoadHandler()
{
	var obj=GetObj("BSendMessage");
	if (obj) obj.onclick=BSendMessage_click;
	var obj=GetObj("BTel");
	if (obj) obj.onclick=BTel_click;
	var obj=GetObj("DealRemark");
	if (obj) obj.ondblclick=DealRemark_DBLClick;
	var obj=GetObj("BExport");
	if (obj) obj.onclick=BExport_click;
	var obj=GetObj("BtnExportWord");
	if (obj) obj.onclick=BtnExportWord_click;
	var obj=GetObj("BtnExportWordTest");
	if (obj) obj.onclick=BtnExportWordTest_click;
}

function BtnExportWord_click(){ 
	//alert("�����word"); 
	var WordApp=new ActiveXObject("Word.Application"); 
	var wdCharacter=1 
	var wdOrientLandscape = 1 
	WordApp.Application.Visible=true; //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
	var myDoc=WordApp.Documents.Add();//�����µĿ��ĵ� 
	//WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//ҳ�淽������Ϊ���� 
	WordApp. Selection.ParagraphFormat.Alignment=1 //1���ж���,0Ϊ���� 
	WordApp. Selection.Font.Bold=true; 
	WordApp. Selection.Font.Size=20 
	WordApp. Selection.TypeText("��Σ��Ϣ����"); 
	WordApp. Selection.MoveRight(wdCharacter);��������//��������ַ� 
	WordApp.Selection.TypeParagraph() //������� 
	WordApp. Selection.Font.Size=12 
	WordApp.Selection.TypeParagraph() //������� 
	var myTable=myDoc.Tables.Add (WordApp.Selection.Range,1,7) //1��7�еı�� 
	myTable.Style="������" 
	var aa = "��Σ��Ϣ����" 
	var TableRange;
	
	//�����п�
	myTable.Columns(1).Width=45;
	myTable.Columns(2).Width=35;
	myTable.Columns(3).Width=35;
	myTable.Columns(4).Width=55;
	myTable.Columns(5).Width=80;
	myTable.Columns(6).Width=70;
	myTable.Columns(7).Width=140;
	
	//�����ͷ��Ϣ
	myTable.Cell(1,1).Range.Text ="����";
	myTable.Cell(1,2).Range.Text ="�Ա�";
	myTable.Cell(1,3).Range.Text ="����";
	myTable.Cell(1,4).Range.Text ="�ǼǺ�";
	myTable.Cell(1,5).Range.Text ="��λ/VIP�ȼ�";
	//myTable.Cell(1,6).Range.Text ="��������";
	myTable.Cell(1,6).Range.Text ="�绰";
	myTable.Cell(1,7).Range.Text ="��Σ���";
	//myTable.Cell(1,9).Range.Text ="����";
	//myTable.Cell(1,10).Range.Text ="״̬";
	
	var ExportName="DHCPEHighRisk";
	var obj=document.getElementById("GetExportInfo");
	if (obj) {var encmeth=obj.value} else{var encmeth=""}
	var Info=cspRunServerMethod(encmeth,1,ExportName);
	
	var Row=1;
	while (Info!=""){
		//alert("Info=="+Info);
		var DataArr=Info.split("^");
		var Sort=DataArr[0];
		if (parseInt(Row)>1){
			myTable.Rows.add();//������
			var DataLength=DataArr.length;
			for (i=1;i<=5;i++){
				myTable.Cell(Row,i).Range.Text=DataArr[i];
			}
			for (i=6;i<=7;i++){
				myTable.Cell(Row,i).Range.Text=DataArr[i+1];
			}
		}
		if (Sort=="") break;
		Info=cspRunServerMethod(encmeth,Sort,ExportName);
		Row=Row+1;
	}
	//�����ͷ��ʽ
	for (i= 0;i<7;i++) {
		with (myTable.Cell(1,i+1).Range){
			font.Size = 11;
			Font.Bold = true;
		} 
	}
	row_count = 0; 
	col_count = 0 
	//myDoc.Protect(1)  
}

function BtnExportWordTest_click(){ 
	//alert("�����word"); 
	var WordApp=new ActiveXObject("Word.Application"); 
	var wdCharacter=1 
	var wdOrientLandscape = 1 
	WordApp.Application.Visible=true; //ִ�����֮���Ƿ񵯳��Ѿ����ɵ�word 
	var myDoc=WordApp.Documents.Add();//�����µĿ��ĵ� 
	WordApp.ActiveDocument.PageSetup.Orientation = wdOrientLandscape//ҳ�淽������Ϊ���� 
	WordApp. Selection.ParagraphFormat.Alignment=1 //1���ж���,0Ϊ���� 
	WordApp. Selection.Font.Bold=true 
	WordApp. Selection.Font.Size=20 
	WordApp. Selection.TypeText("��Σ��Ϣ����"); 
	WordApp. Selection.MoveRight(wdCharacter);��������//��������ַ� 
	WordApp.Selection.TypeParagraph()������������������//������� 
	WordApp. Selection.Font.Size=12 
	WordApp.Selection.TypeParagraph()������������������//������� 
	var myTable=myDoc.Tables.Add (WordApp.Selection.Range,1,10) //8��7�еı�� 
	myTable.Style="������" 
	var aa = "��Σ��Ϣ����" 
	var TableRange;
	
	//�����ͷ��ʽ
	for (i= 0;i<10;i++) {
		with (myTable.Cell(1,i+1).Range){
			font.Size = 11; 
		} 
	}
	
	//�����п�
	myTable.Columns(1).Width=50;
	myTable.Columns(2).Width=30;
	myTable.Columns(3).Width=30;
	myTable.Columns(4).Width=60;
	myTable.Columns(5).Width=100;
	myTable.Columns(6).Width=60;
	myTable.Columns(7).Width=50;
	myTable.Columns(8).Width=200;
	myTable.Columns(9).Width=120;
	myTable.Columns(10).Width=40;
	
	
	//�����ͷ��Ϣ
	myTable.Cell(1,1).Range.Text ="����";
	myTable.Cell(1,2).Range.Text ="�Ա�";
	myTable.Cell(1,3).Range.Text ="����";
	myTable.Cell(1,4).Range.Text ="�����";
	myTable.Cell(1,5).Range.Text ="��λ";
	myTable.Cell(1,6).Range.Text ="��������";
	myTable.Cell(1,7).Range.Text ="�ֻ�����";
	myTable.Cell(1,8).Range.Text ="���";
	myTable.Cell(1,9).Range.Text ="����";
	myTable.Cell(1,10).Range.Text ="״̬";
	
	var ExportName="DHCPEHighRisk";
	var obj=document.getElementById("GetExportInfo");
	if (obj) {var encmeth=obj.value} else{var encmeth=""}
	var Info=cspRunServerMethod(encmeth,1,ExportName);
	
	var Row=1;
	while (Info!=""){
		//alert("002");
		myTable.Rows.add();//������
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++){
			myTable.Cell(Row,i).Range.Text=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		Info=cspRunServerMethod(encmeth,Sort,ExportName);
	}
	row_count = 0; 
	col_count = 0 
	myDoc.Protect(1) 
}

function BExport_click()
{
	var obj;
	obj=document.getElementById("prnpath");
	if (obj&& ""!=obj.value) {
		var prnpath=obj.value;
		var Templatefilepath=prnpath+'DHCPEExportCommon.xls';
	}else{
		alert("��Чģ��·��");
		return;
	}
	var ExportName="DHCPEHighRisk"
	var obj=document.getElementById("GetExportInfo");
	if (obj) {var encmeth=obj.value} else{var encmeth=""}
	xlApp= new ActiveXObject("Excel.Application"); //�̶�
	xlApp.UserControl = true;
    xlApp.visible = true; //��ʾ
	xlBook= xlApp.Workbooks.Add(Templatefilepath); //�̶�
	xlsheet= xlBook.WorkSheets("Sheet1"); //Excel�±������
	var Info=cspRunServerMethod(encmeth,"",ExportName);
	
	var Row=1;
	while (Info!="")
	{
		var DataArr=Info.split("^");
		var DataLength=DataArr.length;
		for (i=1;i<DataLength;i++)
		{
			xlsheet.cells(Row,i).value=DataArr[i];
		}
		var Sort=DataArr[0];
		if (Sort=="") break;
		Row=Row+1;
		Info=cspRunServerMethod(encmeth,Sort,ExportName);
	}
	/*
	xlsheet.SaveAs("d:\\"+ExportName+".xls");	
	xlApp.Visible= true;
	xlApp.UserControl= true;
	*/
	xlBook.Close(savechanges = true);
	xlApp.Quit();
	xlApp = null;
	xlsheet = null;

}
function DealRemark_DBLClick()
{
	var Name=GetValue("Name");
	var IDCard=GetValue("IDCard");
	
	var obj=document.getElementById("TVIPLevelz"+SelRow);
	if (obj) var VIPLevel=obj.innerText;
	
	var Active="1";
	var url='websys.lookup.csp';
	url += "?ID=&CONTEXT=K"+"web.DHCPE.MessageTemplet:FindMessageTemplet";
	url += "&TLUJSF=SetDealRemak"
	url += "&P1="+VIPLevel
	url += "&P4="+Active
	;
	websys_lu(url,1,'');
	return websys_cancel();
}
function SetDealRemak(value)
{
	if (value=="") return false;
	var Arr=value.split("^");
	var OldRemak=GetValue("DealRemark");
	SetValue("DealRemark",Arr[1]+";"+OldRemak);
}
function BTel_click()
{
	if (SelRow==""){
		alert("��ѡ���������Ա");
		return false;
	}
	var encmeth="";
	var obj=document.getElementById("SendMessageClass");
	if (obj) encmeth=obj.value;
	var obj=document.getElementById("TPAADMz"+SelRow);
	if (obj) var PAADM=obj.value;
	var obj=document.getElementById("TEDIDz"+SelRow);
	if (obj) var EDID=obj.value;
	var obj=document.getElementById("TSourceIDz"+SelRow);
	if (obj) var SourceID=obj.value;
	if (SourceID==""){
		var ID=PAADM+","+EDID;
		var Type="TRC";
	}else{
		var ID=SourceID;
		var Type="THR";
	}
	var obj=document.getElementById("TRegNoz"+SelRow);
	if (obj) var RegNo=obj.innerText;
	var obj=document.getElementById("Tel");
	if (obj) var TTel=obj.value;
	trim(TTel)
	var MessageTemplate="";
	var obj=document.getElementById("DealRemark");
	if (obj) MessageTemplate=obj.value;
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	var ret=cspRunServerMethod(encmeth,Type,InfoStr);
	if (ret!=0){
		alert(ret)
		return false;
	}
	var obj=document.getElementById("DealOtherRecord");
	if (obj) encmeth=obj.value;
	var AllID=GetOtherRecord(PAADM,"T");
	var ret=cspRunServerMethod(encmeth,AllID);
	alert("����ɹ�");
}
function GetOtherRecord(OldPAADM,OldType)
{
	var objtbl=document.getElementById('tDHCPEHighRiskNew_List');	//ȡ���Ԫ��?����
	var rows=objtbl.rows.length;
	var ret="";
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TPAADMz"+i);
		if (obj) var PAADM=obj.value;
		if (OldPAADM!=PAADM) continue;
		
		var obj=document.getElementById("THadSendz"+i);
		if (obj) var HadSend=obj.innerText;
		//if ((HadSend!="")&&(HadSend!=" ")) continue;
		var obj=document.getElementById("TEDIDz"+i);
		if (obj) var EDID=obj.value;
		var obj=document.getElementById("TSourceIDz"+i);
		if (obj) var SourceID=obj.value;
		if (SourceID==""){
			var ID=PAADM+","+EDID;
			var Type=OldType+"RC";
		}else{
			var ID=SourceID;
			var Type=OldType+"HR";
		}
		var OneInfo=ID+"^"+Type;
		if (ret==""){
			ret=OneInfo;
		}else{
			ret=ret+"$"+OneInfo
		}
	}
	return ret;
}
function BSendMessage_click()
{
	if (SelRow==""){
		alert("��ѡ���������Ա");
		return false;
	}
	var encmeth="";
	var obj=document.getElementById("SendMessageClass");
	if (obj) encmeth=obj.value;
	
	var obj=document.getElementById("TPAADMz"+SelRow);
	if (obj) var PAADM=obj.value;
	var obj=document.getElementById("TEDIDz"+SelRow);
	if (obj) var EDID=obj.value;
	var obj=document.getElementById("TSourceIDz"+SelRow);
	if (obj) var SourceID=obj.value;
	if (SourceID==""){
		var ID=PAADM+","+EDID;
		var Type="RC";
	}else{
		var ID=SourceID;
		var Type="HR";
	}
	var obj=document.getElementById("TRegNoz"+SelRow);
	if (obj) var RegNo=obj.innerText;
	var obj=document.getElementById("Tel");
	if (obj) var TTel=obj.value;
	trim(TTel)
	if (TTel==""){
		alert("���Ͷ��ŵ绰����Ϊ��");
		return false;
	}
	if (!isMoveTel(TTel)){
		alert("�绰�����ƶ��绰");
		return false;
	}
	var MessageTemplate="";
	var obj=document.getElementById("DealRemark");
	if (obj) MessageTemplate=obj.value;
	if (MessageTemplate==""){
		alert("�������ݲ���Ϊ��");
		return false;
	}
	var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
	var ret=cspRunServerMethod(encmeth,Type,InfoStr);
	if (ret!=0){
		alert(ret)
		return false;
	}
	var obj=document.getElementById("DealOtherRecord");
	if (obj) encmeth=obj.value;
	var AllID=GetOtherRecord(PAADM,"");
	var ret=cspRunServerMethod(encmeth,AllID);
	alert("����ɹ�");
	/*
	var objtbl=document.getElementById('tDHCPEHighRiskNew_List');	//ȡ���Ԫ��?����
	var rows=objtbl.rows.length;
	var ErrRows="";
	var NullTelRows="";
	var ErrTelRows="";
	for (var i=1;i<rows;i++)
	{
		var obj=document.getElementById("TSendz"+i);
		if (obj&&obj.checked){
			var obj=document.getElementById("TPAADMz"+i);
			if (obj) var PAADM=obj.value;
			var obj=document.getElementById("TEDIDz"+i);
			if (obj) var EDID=obj.value;
			var obj=document.getElementById("TSourceIDz"+i);
			if (obj) var SourceID=obj.value;
			if (SourceID==""){
				var ID=PAADM+","+EDID;
				var Type="RC";
			}else{
				var ID=SourceID;
				var Type="HR";
			}
			var obj=document.getElementById("TRegNoz"+i);
			if (obj) var RegNo=obj.innerText;
			var obj=document.getElementById("TTelz"+i);
			if (obj) var TTel=obj.value;
			trim(TTel)
			if (TTel==""){
				NullTelRows=NullTelRows+"^"+i;
				continue;
			}
			if (!isMoveTel(TTel)){
				ErrTelRows=ErrTelRows+"^"+i;
				continue;
			}
			var obj=document.getElementById("TMessageDetailz"+i);
			if (obj) var MessageTemplate=obj.value;
			var InfoStr=ID+"^"+RegNo+"^"+TTel+"^"+MessageTemplate;
			var ret=cspRunServerMethod(encmeth,Type,InfoStr);
			if (ret!=0){
				ErrRows=ErrRows+"^"+i;
			}
		}
	}
	if ((ErrRows!="")||(NullTelRows!="")||(ErrTelRows!="")){
		if (ErrRows!="")alert("�����к�:"+ErrRows);
		if (NullTelRows!="")alert("�绰Ϊ�յ��к�:"+NullTelRows);
		if (ErrTelRows!="")alert("�ֻ����������к�:"+NullTelRows);
	}else{
		window.location.reload();
	}*/
}
function GetObj(ElementName)
{
	return document.getElementById(ElementName)
}
function GetValue(ElementName)
{
	var obj=GetObj(ElementName)
	if (obj){
		return obj.value;
	}else{
		return "";
	}
}
function SetValue(ElementName,value)
{
	var obj=GetObj(ElementName);
	if (obj) obj.value=value;
}
function trim(s) {
	var m = s.match(/^\s*(\S+(\s+\S+)*)\s*$/);
	return (m == null) ? "" : m[1];
}
///�ж��ƶ��绰
function isMoveTel(elem){
	if (elem=="") return true;
	var pattern=/^0{0,1}13|15|18[0-9]{9}$/;
	if(pattern.test(elem)){
		return true;
	}else{

	return false;
 	}
}
function SelectRowHandler()	
{	
	var eSrc = window.event.srcElement;	//�����¼���
	var objtbl=document.getElementById('tDHCPEHighRiskNew_List');	//ȡ���Ԫ��?����
	var rows=objtbl.rows.length;	
	var lastrowindex=rows - 1;
	var rowObj=getRow(eSrc);
	var selectrow=rowObj.rowIndex;
    if (!selectrow) return;
	if (selectrow==SelRow){
		return false;
	}
	var OldPAADM="",NewPAADM="";
	var obj=document.getElementById("TPAADMz"+SelRow);
	if (obj) OldPAADM=obj.value;
	SelRow=selectrow;
	var Tel="",Result="";
	var obj=document.getElementById("TTelz"+SelRow);
	if (obj) var Tel=obj.innerText;
	SetValue("Tel",Tel);
	var obj=document.getElementById("TEDResultz"+SelRow);
	if (obj) var Result=obj.innerText;
	var obj=document.getElementById("TPAADMz"+SelRow);
	if (obj) NewPAADM=obj.value;
	if (OldPAADM==NewPAADM){
		var OldResult=GetValue("DealRemark");
		SetValue("DealRemark",OldResult+";"+Result);
	}else{
		SetValue("DealRemark",Result);
	}
	//SetValue("DealRemark","");
}