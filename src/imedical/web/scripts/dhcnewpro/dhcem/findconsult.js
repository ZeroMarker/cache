///qqa
var LgLocID = session['LOGON.CTLOCID'];  /// ����ID
var LgHospID = session['LOGON.HOSPID'];  /// ҽԺID
var LgGroupID = session['LOGON.GROUPID'] /// ��ȫ��ID
var CstTypeArr = [{"value":"A","text":$g('ƽ���ﳬʱ')}, {"value":"B","text":$g('�����ﳬʱ')}];
$(function(){
	
	initParams();
	
	initCombobox();
	
	initTable();

	initMethod();
	
})



function initParams(){
	episodeID = getParam("EpisodeID");
}
	
function initCombobox(){
   var LgLocID = session['LOGON.CTLOCID'];
	/// ��ʼ����
	var Days=Number(FindStDay) //hxy 2021-06-23 st
	if((trim(FindStDay)=="")||(isNaN(FindStDay))){
		Days=-7;
	}else{
		Days=0-Days;
	}
	$HUI.datebox("#stDate").setValue(GetCurSystemDate(Days)); //ed ԭ��-7 
	/// ��������
	$HUI.datebox("#endDate").setValue(GetCurSystemDate(0));
	
	$HUI.combobox("#consultStauts",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=jsonConsStat&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
	})
	$HUI.combobox("#consultStauts").setValue(3);
	
	$HUI.combobox("#consultLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	
	$HUI.combobox("#consRLoc",{
		url: LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonLoc&HospID="+HospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		mode:'remote'
	})
	$HUI.combobox("#consRLoc").setValue(session['LOGON.CTLOCID']); /// Ĭ�ϵ�ǰ��¼���� bianshuai 2018-12-11
    
	if(LgLocID=="95"){
    $("#consRLoc").attr("readOnly",true); 
	}
	
	//�������� hxy 2021-03-18
	$HUI.combobox("#consNature",{
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonCstProp&LgHospID="+LgHospID, //hxy 2020-05-29 add LgHospID
		valueField: "itmID", 
		textField: "itmDesc",
		editable:true	
	})
    
   $HUI.combobox("#crsTime",{
		//url: LINK_CSP+"?ClassName=web.DHCEMConsStatus&MethodName=jsonConsStat&HospID="+HospID,
		data:CstTypeArr,
		valueField: "value", 
		textField: "text",
		editable:true
	})
	
	/// �������� 2021-06-23
	$HUI.combobox("#CstType",{ 
		url:LINK_CSP+"?ClassName=web.DHCEMConsultCom&MethodName=JsonAllCstType&HospID="+LgHospID,
		valueField: "value", 
		textField: "text",
		editable:true,
		onLoadSuccess:function(data){
	    }	
	})
}
	
function initTable(){
	
	var columns=[[
		{ field: 'CstID',align: 'center', title: 'CstID',hidden:true},
		{ field: 'CstItmID',align: 'center', title: 'CstItmID',hidden:true},
		//{ field: 'Detail',align: 'center', title: '��ϸ',width:40,formatter:formatDetail},
		{ field: 'Detail',align: 'center', title: '��ϸ',width:40,formatter:closedLoop},
		{ field: 'CstRLoc',align: 'center', title: '�������',width:100},
		{ field: 'CstUser',align: 'center', title: '������',width:100},
		{ field: 'CstUserJobNum',align: 'center', title: '�����˹���',width:100},
		{ field: 'CstLoc',align: 'center', title: '�������',width:200},
		{ field: 'CareProv',align: 'center', title: '������',width:100},
		{ field: 'CareProvJobNum',align: 'center', title: '�����˹���',width:100},
		{ field: 'PatName',align: 'center', title: '��������',width:120},
		{ field: 'PatSex',align: 'center', title: '�Ա�',width:60},
		{ field: 'PatNo',align: 'center', title: '�ǼǺ�',width:120}, //hxy 2021-05-28
		{ field: 'PatMrNo',align: 'center', title: '������',width:100}, //hxy 2021-07-09
		{ field: 'PatWard',align: 'center', title: '����',width:150},
		{ field: 'PatBed',align: 'center', title: '����',width:80},
		{ field: 'PatDiagDesc',align: 'center', title: '���',width:180},
		{ field: 'CstTrePro',align: 'center', title: '��Ҫ��ʷ',width:180,formatter:SetCellField}, //hxy 2021-02-02 st Ӣ�Ļ��� //,wordBreak:'break-all'
		{ field: 'CstPurpose',align: 'center', title: '�������ɼ�Ҫ��',width:180,formatter:SetCellField}, //,wordBreak:'break-all'
		{ field: 'CsOpinion',align: 'center', title: '�������',width:250,formatter:SetCellField}, //ed �ӻ�����������ַ����� //,wordBreak:'break-all'
		{ field: 'CstDate',align: 'center', title: '��������',width:120},
		{ field: 'CstTime',align: 'center', title: '����ʱ��',width:120},
		{ field: 'CstNDate',align: 'center', title: '��������',width:120},
		{ field: 'CstNTime',align: 'center', title: '����ʱ��',width:120},
		{ field: 'ArrDate',align: 'center', title: '��������',width:120}, //hxy 2021-04-02 st
		{ field: 'ArrTime',align: 'center', title: '����ʱ��',width:120}, //ed
		{ field: 'ComDate',align: 'center', title: '�������',width:120}, //hxy 2021-04-13 st
		{ field: 'ComTime',align: 'center', title: '���ʱ��',width:120}, //ed
		{ field: 'CsSurTime',align: 'center', title: '����ʣ��ʱ��',width:120,formatter:setSurTime}, //hxy 2021-03-18
		{ field: 'CsOverTime',align: 'center', title: '���ﳬʱʱ��',width:120}, //hxy 2021-03-19
		{ field: 'CstStatus',align: 'center', title: '��ǰ״̬',width:120},
		{ field: 'CstType',align: 'center', title: '��������',width:120}, //hxy 2021-06-23 ����->����
		{ field: 'CsProp',align: 'center', title: '��������',width:120}, //hxy 2021-03-18
		{ field: 'CstNPlace',align: 'center', title: '����ص�',width:100}, //2021-07-09
		{ field: 'REva',align: 'center', title: '�������۱�',width:100,formatter:formatREva},
		{ field: 'CEva',align: 'center', title: '�������۱�',width:100,formatter:formatCEva},
		{ field: 'AdmType',align: 'center', title: '��������',width:100,formatter:formatType}
	]];
	$HUI.datagrid("#mainLisTable",{
		title:$g('�����ѯ'),
		headerCls:'panel-header-gray',
		iconCls:'icon-paper',
		toolbar:"#toolbar",
		url:LINK_CSP+"?ClassName=web.DHCEMFindConsult&MethodName=GetConsultList",
		queryParams:{
			Params:getParams()
		},
		fit:true,
		rownumbers:true,
		columns:columns,
		autoSizeColumn:true,
		pageSize:20,  
		pageList:[20,35,50], 
	    singleSelect:true,
		loadMsg: $g('���ڼ�����Ϣ...'),
		pagination:true,
		//nowrap:false, //hxy 2021-07-23 ע��
		onClickRow:function(rowIndex, rowData){
			if(rowData.CstStatus=="���"){
				$("#bt_off").linkbutton("disable");
			}else{
				$("#bt_off").linkbutton("enable");
			}
	    },
	    onDblClickRow: function (rowIndex, rowData) {

        },
        onLoadSuccess:function(data){
			BindTips(); /// ����ʾ��Ϣ
		}
	})

}

/// ���������ַ�
function SetCellField(value, rowData, rowIndex){
	return $_TrsTxtToSymbol(value);
}
	
function initMethod(){
	$('#PatNo').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
            RegNoBlur();
        }
    });	
	
}

function commonPrint(){
		
}

function commonExport(){
	runClassMethod("web.DHCEMFindConsult","GetExportDate",{"UserID":UserID},function(retData){
		exportExecl(retData);
	})		
}

function exportExecl(data){
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     			/// ��������
	if(!data.length){
		$.messager.alert("��ʾ","�޵������ݣ�");
		return;	
	}
	var Str = "(function test(x){"+
	"var xlApp = new ActiveXObject('Excel.Application');"+
	"var xlBook = xlApp.Workbooks.Add();"+
	"var objSheet = xlBook.ActiveSheet;"+
	"xlApp.Range(xlApp.Cells(1,1),xlApp.Cells(1,33)).MergeCells = true;"+ //�ϲ���Ԫ��
	"objSheet.cells(1,1).Font.Bold = true;"+
	"objSheet.cells(1,1).Font.Size =24;"+
	"objSheet.cells(1,1).HorizontalAlignment = -4108;"+
	"objSheet.Cells(1,1).value='ͳ��ʱ��:"+stDate+"��"+endDate+"';";
	var beginRow=2;
	Str=Str+"objSheet.Cells(2,1).value='�������';"+ 
	"objSheet.Cells(2,2).value='������';"+
	"objSheet.Cells(2,3).value='�����˹���';"+
	"objSheet.Cells(2,4).value='�������';"+
	"objSheet.Cells(2,5).value='������';"+
	"objSheet.Cells(2,6).value='�����˹���';"+	 
	"objSheet.Cells(2,7).value='��������';"+ 	
	"objSheet.Cells(2,8).value='�Ա�';"+
	"objSheet.Cells(2,9).value='�ǼǺ�';"+
	"objSheet.Cells(2,10).value='������';"+ 	 
	"objSheet.Cells(2,11).value='����';"+ 
	"objSheet.Cells(2,12).value='����';"+ 
	"objSheet.Cells(2,13).value='���';"+ 
	"objSheet.Cells(2,14).value='��Ҫ��ʷ';"+
	"objSheet.Cells(2,15).value='�������ɼ�Ҫ��';"+
	"objSheet.Cells(2,16).value='�������';"+ 
	"objSheet.Cells(2,17).value='��������';"+ 
	"objSheet.Cells(2,18).value='����ʱ��';"+
	"objSheet.Cells(2,19).value='��������';"+
	"objSheet.Cells(2,20).value='����ʱ��';"+
	"objSheet.Cells(2,21).value='��������';"+
	"objSheet.Cells(2,22).value='����ʱ��';"+
	"objSheet.Cells(2,23).value='�������';"+
	"objSheet.Cells(2,24).value='���ʱ��';"+
	"objSheet.Cells(2,25).value='����ʣ��ʱ��';"+
	"objSheet.Cells(2,26).value='���ﳬʱʱ��';"+	 
	"objSheet.Cells(2,27).value='��ǰ״̬';"+ 	 
	"objSheet.Cells(2,28).value='��������';"+
	"objSheet.Cells(2,29).value='��������';"+ //hxy 2021-03-18
	"objSheet.Cells(2,30).value='����ص�';"+
	"objSheet.Cells(2,31).value='�������۱�';"+
	"objSheet.Cells(2,32).value='�������۱�';"+
	"objSheet.Cells(2,33).value='��������';";
	Str=Str+"objSheet.Columns(17).NumberFormatLocal='@';"; //hxy 2020-04-14
	Str=Str+"objSheet.Columns(3).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(6).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(9).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(10).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(19).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(21).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(23).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(25).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(26).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(31).NumberFormatLocal='@';";
	Str=Str+"objSheet.Columns(32).NumberFormatLocal='@';";
	for (var i=0;i<data.length;i++){
		Str=Str+"objSheet.Cells("+(i+beginRow+1)+","+1+").value='"+data[i].CstRLoc+"';"+       
		"objSheet.Cells("+(i+beginRow+1)+","+2+").value='"+data[i].CstUser+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+3+").value='"+data[i].CstUserJobNum+"';"+      
		"objSheet.Cells("+(i+beginRow+1)+","+4+").value='"+data[i].CstLoc+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+5+").value='"+data[i].CareProv+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+6+").value='"+data[i].CareProvJobNum+"';"+  
		"objSheet.Cells("+(i+beginRow+1)+","+7+").value='"+data[i].PatName+"';"+ 	 
		"objSheet.Cells("+(i+beginRow+1)+","+8+").value='"+data[i].PatSex+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+9+").value='"+data[i].PatNo+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+10+").value='"+data[i].PatMrNo+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+11+").value='"+data[i].PatWard+"';"+ 	 
		"objSheet.Cells("+(i+beginRow+1)+","+12+").value='"+data[i].PatBed+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+13+").value='"+data[i].PatDiagDesc+"';"+ 
		"objSheet.Cells("+(i+beginRow+1)+","+14+").value='"+data[i].CstTrePro.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+ 			
		"objSheet.Cells("+(i+beginRow+1)+","+15+").value='"+data[i].CstPurpose.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+16+").value='"+data[i].CsOpinion.replace(/\n/g,"\\n").replace(/\'/g,"\\'")+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+17+").value='"+data[i].CstDate+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+18+").value='"+data[i].CstTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+19+").value='"+data[i].CstNDate+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+20+").value='"+data[i].CstNTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+21+").value='"+data[i].ArrDate+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+22+").value='"+data[i].ArrTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+23+").value='"+data[i].ComDate+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+24+").value='"+data[i].ComTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+25+").value='"+data[i].CsSurTime+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+26+").value='"+data[i].CsOverTime+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+27+").value='"+data[i].CstStatus+"';"+ 		
		"objSheet.Cells("+(i+beginRow+1)+","+28+").value='"+data[i].CstType+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+29+").value='"+data[i].CsProp+"';"+ //hxy 2021-03-18
		"objSheet.Cells("+(i+beginRow+1)+","+30+").value='"+data[i].CstNPlace+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+31+").value='"+data[i].REva+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+32+").value='"+data[i].CEva+"';"+
		"objSheet.Cells("+(i+beginRow+1)+","+33+").value='"+data[i].AdmType+"';";
	}
	var row1=beginRow,row2=data.length+beginRow,c1=1,c2=33;
	Str=Str+"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(1).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(2).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).LineStyle=1;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(3).Weight=2;"+
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).LineStyle=1;"+ 
	"objSheet.Range(objSheet.Cells("+row1+","+c1+"),objSheet.Cells("+row2+","+c2+")).Borders(4).Weight=2;"+
	"xlApp.Range(xlApp.Cells(1,13),xlApp.Cells("+data.length+beginRow+",13)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,14),xlApp.Cells("+data.length+beginRow+",14)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,15),xlApp.Cells("+data.length+beginRow+",15)).WrapText = true;"+
	"xlApp.Range(xlApp.Cells(1,16),xlApp.Cells("+data.length+beginRow+",16)).WrapText = true;"+
	"xlApp.Visible=true;"+
	"objSheet.Columns.AutoFit;"+
	"xlApp=null;"+
	"xlBook=null;"+
	"objSheet=null;"+
	"return 1;}());";
	 //����Ϊƴ��Excel��ӡ����Ϊ�ַ���
    CmdShell.notReturn = 1;   //�����޽�����ã�����������
	var rtn = CmdShell.CurrentUserEvalJs(Str);   //ͨ���м�����д�ӡ���� 
	return;	
}

/// ��ѯͳ���б�
function commonQuery(){
	$HUI.datagrid("#mainLisTable").load({"Params":getParams()});
}

function commonOff(){
	var rows = $HUI.datagrid("#mainLisTable").getSelections();
	if(!rows.length){
		$.messager.alert("��ʾ","��ѡ��һ�����ݣ�");
		return;
	}
	var CstID = rows[0].CstID;
	runClassMethod("web.DHCEMConsult","CanCstNo",{"CstID":CstID,"UserID":UserID},function(retString){
		if(retString==0){
			$.messager.alert("��ʾ","���ϳɹ�!");
			commonQuery();    //ˢ��
		}
	},'text')	
}

function getParams(){
	var stDate = $HUI.datebox("#stDate").getValue(); 				/// ��ʼ����
	var endDate = $HUI.datebox("#endDate").getValue();     			/// ��������
	var cstRLocID = $HUI.combobox("#consRLoc").getValue()==undefined?"":$HUI.combobox("#consRLoc").getValue();   //�������
	var cstLocID = $HUI.combobox("#consultLoc").getValue()==undefined?"":$HUI.combobox("#consultLoc").getValue();      //���տ���
	var cstStauts = $HUI.combobox("#consultStauts").getValue()==undefined?"":$HUI.combobox("#consultStauts").getValue(); //״̬
	var crsTime ="" ; 
	//$HUI.combobox("#crsTime").getValue()==undefined?"":$HUI.combobox("#crsTime").getValue(); //�Ƿ�ʱ
	var consNature = $HUI.combobox("#consNature").getValue()==undefined?"":$HUI.combobox("#consNature").getValue(); //��������
	var overTime = $HUI.radio("#overTime").getValue()?"Y":"N"; //hxy 2021-03-23
	var PatName=$("#PatName").val();
	var PatNo=$("#PatNo").val();
	var CstType = $HUI.combobox("#CstType").getValue()==undefined?"":$HUI.combobox("#CstType").getValue(); //����
	var DOCA = $HUI.radio("#DOCA").getValue()?"Y":"N"; //hxy 2022-09-01 st
	var DOCARes = $HUI.radio("#DOCARes").getValue()?"Y":"N"; //ed
	var AdmTypeO=$HUI.checkbox("#O").getValue()?"O":"";
	var AdmTypeE=$HUI.checkbox("#E").getValue()?"E":"";
	var AdmTypeI=$HUI.checkbox("#I").getValue()?"I":"";
	var AdmTypeOEI=AdmTypeO+AdmTypeE+AdmTypeI;
    /// ���¼��ػ����б�
	var params = stDate+"^"+endDate+"^"+cstRLocID+"^"+cstLocID+"^"+cstStauts+"^"+UserId+"^"+overTime+"^"+LgHospID+"^"+consNature+"^"+PatName+"^"+PatNo+"^"+CstType;
	var params = params+"^"+DOCA+"^"+DOCARes+"^"+AdmTypeOEI;
	return params;
}

function gridlist(objSheet,row1,row2,c1,c2)
{
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(1).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(2).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).LineStyle=1;
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(3).Weight=2
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).LineStyle=1; 
	objSheet.Range(objSheet.Cells(row1, c1), objSheet.Cells(row2,c2)).Borders(4).Weight=2
}

/// ��ȡϵͳ��ǰ����
function GetCurSystemDate(offset){
	
	var SysDate = "";
	runClassMethod("web.DHCEMConsultCom","GetCurSystemDate",{"offset":offset},function(jsonString){

		if (jsonString != ""){
			SysDate = jsonString;
		}
	},'',false)
	return SysDate
}


function formatDetail(value, rowData, rowIndex){
	return '<a href="#" onclick="openCstDetail(\''+rowData.CstID+'\',\''+rowData.CstItmID+'\',\''+rowData.TypeCode+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
}

/// �ջ� bianshuai 2021-07-30
function closedLoop(value, rowData, rowIndex){
	if(HISUIStyleCode==="lite"){ //hxy 2023-02-06
			return '<a href="#" class="icon-write-order" onclick="openClosedLoop(\''+rowData.Oeori+'\',\''+rowData.CstItmID+'\')"></a>';
	}else{
	return '<a href="#" onclick="openClosedLoop(\''+rowData.Oeori+'\',\''+rowData.CstItmID+'\')"><img src="../scripts/dhcnewpro/images/adv_sel_8.png" border="0/"></a>';
	}
}

/// �ջ� bianshuai 2021-07-30
function openClosedLoop(Oeori,CstItmID){
	var iLeft = ($(window).width()-1280)/2; //��ô��ڵ�ˮƽλ��;
	var iTop=($(window).height()-640)/2; //��ô��ڵĴ�ֱλ��;
	var lnk = "dhc.orderview.csp?ord="+Oeori+"&ordViewType=CST&ordViewBizId="+CstItmID;
	websys_showModal({
		url: lnk,
		height:640,
		width:1280, //hxy 2021-05-07 890->1280 ���õ������ɹر�
		left:iLeft,
		top:iTop,
		iconCls:"icon-w-paper",
		title: $g('������ϸ'),
		closed: true,
		onClose:function(){}
	});	
}

function openCstDetail(CstID,CstItmID,TypeCode){
	if(TypeCode=="NUR"){ //hxy 2020-09-18 st
		var lnk = "dhcem.consultnur.csp?CstID="+CstID+"&CstItmID="+CstItmID+"&seeCstType=1"
	}else{//ed
	var lnk = "dhcem.consultwrite.csp?CstID="+CstID+"&CstItmID="+CstItmID+"&seeCstType=1"
	}
	websys_showModal({
		url: lnk,
		height:640,
		width:1280, //hxy 2021-05-07 890->1280 ���õ������ɹر�
		iconCls:"icon-w-paper",
		title: $g('������ϸ'),
		closed: true,
		onClose:function(){}
	});	
}

function formatREva(value, rowData, rowIndex){
	/*var ComTime=rowData.ComTime;
	if(ComTime==""){
		return $g("����δ���");
	}*/
	return "<a style='text-decoration:none;' href=\"javascript:void(openREva('"+rowData.CstItmID+"'));\">"+value+"</a>";
}

function formatCEva(value, rowData, rowIndex){
	/*var ComTime=rowData.ComTime;
	if(ComTime==""){
		return $g("����δ���");
	}*/
	return "<a style='text-decoration:none;' href=\"javascript:void(openCEva('"+rowData.CstItmID+"'));\">"+value+"</a>";
}

function formatType(value, rowData, rowIndex){
	return "<span>"+$g(value)+"</span>";
}

function openREva(CstItmID){
	var url="dhcem.consapptable.csp?ID="+CstItmID+"&AppTableCode=SHR&SaveMode=R&AppTableTitle=��������&seeCstType=1"
	//window.open (url, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=yes, location=no, status=no") ;
	websys_showModal({
		url: url,
		height:450,
		width:650,
		iconCls:"icon-w-paper",
		title: $g('�������۱�'),
		closed: true,
		onClose:function(){}
	});	
	return false;
}

function openCEva(CstItmID){
	var url="dhcem.consapptable.csp?ID="+CstItmID+"&AppTableCode=SHP&SaveMode=C&AppTableTitle=��������&seeCstType=1";
	//window.open (url, "newwindow", "height=450, width=650, toolbar =no,top=100,left=300,, menubar=no, scrollbars=no, resizable=yes, location=no, status=no") ;
	websys_showModal({
		url: url,
		height:450,
		width:650,
		iconCls:"icon-w-paper",
		title: $g('�������۱�'),
		closed: true,
		onClose:function(){}
	});	
	return false;	
}

///���㷽��
function RegNoBlur()
{
	var i;
    var regno=$('#PatNo').val();
    var oldLen=regno.length;
    if (oldLen==8) return;
	if (regno!="") {  //add 0 before regno
	    for (i=0;i<10-oldLen;i++)
	    {
	    	regno="0"+regno 
	    }
	}
    $("#PatNo").val(regno);
}

/// ����ʾ��
function BindTips(){
	
	var html='<div id="tip" style="word-break:break-all;border-radius:3px; display:none; border:1px solid #000; padding:10px; margin:5px; position: absolute; background-color: #000;color:#FFF;"></div>';
	$('body').append(html);
	
	/// ����뿪
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mouseleave':function(){
			$("#tip").css({display : 'none'});
		}
	})
	/// ����ƶ�
	$('td[field="CstTrePro"],td[field="CstPurpose"],td[field="CsOpinion"]').on({
		'mousemove':function(){
			
			var tleft=(event.clientX + 10);
			if ($(this).text().length <= 20){
				return;
			}
			if ( window.screen.availWidth - tleft < 600){ tleft = tleft - 600;}
			/// tip ��ʾ��λ�ú������趨
			$("#tip").css({
				display : 'block',
				top : (event.clientY + 10) + 'px',   
				left : tleft + 'px',
				//right:10+'px',
				//bottom:5+'px',
				'z-index' : 9999,
				opacity: 0.8
			}).text($(this).text());
		}
	})
}

/// ��ʱʱ�ķ���
function setSurTime(value, rowData, rowIndex){	
	if (rowData.CsSurTime == "��ʱ"){
		rowData.CsSurTime = $g("��ʱ");
	}
	var htmlstr= '<span>'+ rowData.CsSurTime +'</span>';
	return htmlstr;
}


