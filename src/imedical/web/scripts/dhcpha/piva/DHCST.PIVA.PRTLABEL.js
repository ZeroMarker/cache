/**
 * ģ��:������ӡ��ǩ
 * createdate:2015-12-15
 * creator:LiangQiang
 * scripts/dhcpha/piva/DHCST.PIVA.PRTLABEL.js
 */
var url = "DHCST.PIVA.ACTION.csp";
var PhLocDr=session['LOGON.CTLOCID'];
var UserDr=session['LOGON.USERID'];
var CurWardID="";
var CurAdm="";
var CurKFlag=""; // �Ƿ����
$(function(){
	InitDateBox();
	InitPhaLocGrp();
	InitPhInstList();
	InitWardList();
	InitPatNoList();
	InitOrdItmdgList();
	InitOrdItmSmdg();
	InitCurLabel();
	InitPhaLocBatBox(PhLocDr);
	$('#btnFind').bind("click",Query);  // �����ѯ
    //$('#btnOk').bind("click",UpdBatData);
	$('#btnRef').bind("click",QueryDetail);
    $('#btnOk').bind("click",SaveDisp);
	$('#btnPack').bind("click",btnPackHandler);
	$('#btnCancelPack').bind("click",btnCancelPackHandler);
	//�ǼǺ�
    $('#ByPatNo').bind('keypress',function(event){
        if(event.keyCode == "13")    {
            GetPatAdmList(); //���ò�ѯ
        }
    });
    $(".tabs-header").bind('click',function(){
		RefTab();
		CurKFlag=0; //���Ʋ�ˢ��
	})
    //�뿪
	window.onbeforeunload = function(){
		ClearTMP();
	}
});

function InitDateBox(){
	$("#DbSt").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#DBEnd").datebox("setValue", formatDate(0));  //Init��������
}

/// ��ʼ��ҩ��������
function InitPhaLocGrp(){	
	$('#LocGrpCombo').combobox({  
		panelWidth: 200,
		url:url+'?action=GetLocListByGrp&Input='+PhLocDr,  
		valueField:'rowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#LocGrpCombo').combobox('getData');
            if (data.length > 0) {
                  //$('#LocGrpCombo').combobox('select', data[0].rowId);
            }  
	    }
	});

	$('#LocGrpCombo').combobox({
		onHidePanel: function() {
			var valueField = $(this).combobox("options").valueField;
			var val = $(this).combobox("getValue");  //��ǰcombobox��ֵ
			var allData = $(this).combobox("getData");   //��ȡcombobox��������
			var result = true;      //Ϊtrue˵�������ֵ�������������в�����
			for (var i = 0; i < allData.length; i++) {
				 if (val == allData[i][valueField]) {
					 result = false;
				 }
			}
			if (result) {
				$(this).combobox("clear");
				$(this).combobox('setValue', '');
			}
		}
	});		
}

/// ��ʼ���÷��б�
function InitPhInstList(){
	$('#InstCombo').combobox({  
		panelWidth: 140,
		url:url+'?action=GetPhInstList',  
		valueField:'rowId',  
		textField:'Desc'
	});	
}

//��ʼ��ҩƷ�б�
function InitDrugDescDs(){	
	$('#InciCombo').combobox({  
		panelWidth: 140,
		valueField:'rowId',  
		textField:'Desc'
	});	
}

//��ʼ�������б�
function InitWardList(){
	//����columns
	var columns=[[
		{field:'Select',checkbox:true },
		{field:"WardID",title:'WardID',hidden:true},
		{field:'WardDesc',title:'����',width:200}
	]];
	
	//����datagrid
	$('#warddg').datagrid({
		border:false,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		//pageSize:100,  // ÿҳ��ʾ�ļ�¼����
		//pageList:[100],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
	    onClickRow:function(rowIndex,rowData){
		   CurWardID=rowData.WardID;
		   CurAdm="";
		   //QueryDetail();
        },
		singleSelect: false,
		selectOnCheck: true, 
		checkOnSelect: true

	});
    //initScroll("#warddg");
}

function InitPatNoList(){
	//����columns
	var columnspat=[[
	    {field:'RegNo',title:'�ǼǺ�',width:60},
	    {field:'CurrWard',title:'����',width:100},
		{field:'Adm',title:'adm',width:60,hidden:true},
		{field:'AdmDate',title:'��������',width:100},
		{field:'AdmTime',title:'����ʱ��',width:100},
		{field:'AdmLoc',title:'�������',width:100},		
		{field:'CurrWardID',title:'����ID',width:100,hidden:true},
		{field:'CurrBed',title:'����',width:100},
		{field:'CurrDoc',title:'ҽ��',width:100}
		
	]];
	
	//����datagrid
	$('#admdg').datagrid({
		url:'',
		toolbar:'#admdgBar',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columnspat,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80,120,160],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
	    onClickRow:function(rowIndex,rowData){
		     CurAdm=rowData.Adm;
			 CurWardID="";
		     QueryDetail();
		   }
	});
	//initScroll("#admdg");
}

/// ��ʼ����ϸ�б�
function InitOrdItmdgList(){
	var columnspat=[[
		//{field:'TbSelect',checkbox:true },
        {field:"TbSttD",title:'��ҩʱ��',width:140},
		{field:'TbBatNo',title:'����',width:50,
		  editor:{type:'validatebox',options:{required:'true'} }
		 },	
		{field:'TbBedNo',title:'����',width:50},
		{field:"TbName",title:'����',width:60},
		{field:'TbItmDesc',title:'��ҩ',width:230},
		{field:'TbItmDescSub',title:'��ý',width:230},
		{field:'TbDosage',title:'����',width:50}, 
		{field:'TbFreq',title:'Ƶ��',width:50},
		{field:'TbQty',title:'����',width:50},
		{field:'TbUomdesc',title:'��λ',width:50},
		{field:'TbInstruc',title:'�÷�',width:80},
		{field:'TbDoctor',title:'ҽ��',width:50},
		{field:'TbPackState',title:'���״̬',width:60},
		{field:"TbPatNo",title:'�ǼǺ�',width:85,hidden:true},
		{field:"TbMDsp",title:'TbMDsp',width:50,hidden:true},
		{field:'TbAdmcolor',title:'��ɫ',width:50,hidden:true},
		{field:'TbPID',title:'PID',width:50,hidden:true},
		{field:'TbDspStr',title:'TbDspStr',width:200,hidden:true}
	]];
	                                                          
	$('#ordtimdg').datagrid({
		url:'',
		fit:true,
		border:false,
		singleSelect:true,
		checkOnSelect: true,
		rownumbers:false,
		columns:columnspat,
		pageSize:200,  // ÿҳ��ʾ�ļ�¼����
		pageList:[200],   // ��������ÿҳ��¼�������б�
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		rowStyler:function(index,row){  
			if (row.TbAdmcolor==1){  
				return 'background-color:C4FEFF;';  
			}    
		}, 
	   	onClickRow:function(rowIndex,rowData){
		   var MDsp=rowData.TbMDsp;
		   GetCurBatInfo(MDsp);
	    }
	
	});
	$('#ordtimdg').datagrid('loadData',{total:0,rows:[]});
    //initScroll("#ordtimdg");
}

/// ��ʼ�������б�
function InitOrdItmSmdg(){
	//����columns
	var columnssum=[[
		{field:'TbDesc',title:'ҩƷ',width:230},
		{field:'TbQty',title:'����',width:50},
		{field:'TbUom',title:'��λ',width:50}
	]];
	                                                          
	//����datagrid
	$('#ordtimsumdg').datagrid({
		url:'',
		fit:true,
		border:false,
		singleSelect:true,
		rownumbers:true,
		columns:columnssum,
		pageSize:300,  // ÿҳ��ʾ�ļ�¼����
		pageList:[300,600],   // ��������ÿҳ��¼�������б�
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true
	
	});
    //initScroll("#ordtimsumdg");
}

/// ��ǰƿǩ
function InitCurLabel(){
	//����columns
	var columnspat=[[
	    {field:'drug',title:'ҩƷ',width:180},
		{field:'freq',title:'Ƶ��',width:50},
		{field:'dose',title:'����',width:60},
		{field:'oeorestat',title:'ִ�м�¼״̬',width:50,hidden:true}
		
	]];
	
	//����datagrid
	$('#curlabeldg').datagrid({
		url:'',
		border:false,
		toolbar:'#curlabeldgbar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		//pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		//pageList:[40,80,120,160],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:false,
		rowStyler: function(index,row){
			if (row.oeorestat=="0"){
				return 'color:#ff0066;font-weight:bold';
			}
		},
	    onDblClickRow:function(rowIndex,rowData){
			//var pointer=rowData.CurrWardID;
			//QuerySubDb(inputs);
			//var AdmId=rowData.Adm;
			//QueryResult(pointer,AdmId)
		}
	});
	//initScroll("#curlabeldg");
}

/// ��ȡ��ǰǩ��Ϣ
function InitPhaLocBatBox(PhLocDr){
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetPhaLocBatInfo&Input="+PhLocDr,
       //dataType: "json",
       success: function(val){
            var chkhtml="";
			var tmp=val.split("^");			
			for (i=1;i<=tmp.length;i++){
				 var batstr=tmp[i-1].split(",");
                 var batnoid=i ; //batstr[0];
                 var batnodesc=batstr[1];
				 var tmphtml='<span style="margin-left:10px;"><input style="vertical-align: text-bottom;" id="'+batnoid+'" class="ui-checkbox" name="batbox" type="checkbox" value='+batstr[0]+'>'+batnodesc+'</input></span>'
				 if (chkhtml==""){
                    chkhtml=tmphtml;
				 }else{
					chkhtml=chkhtml+tmphtml;
				 }
			}
			$("#DivBatNo").append(chkhtml);
       }
    })
}


/// ���ǼǺŲ�ѯ�����б�
function GetPatAdmList(){
	var RegNo=$('#ByPatNo').val();
   	var patLen = tkMakeServerCall("web.DHCSTPIVABATUPDATE", "GetPatRegNoLen");
    var plen=RegNo.length;
	if (plen>patLen){
		$.messager.alert('��ʾ','����ǼǺŴ���!','warning');
		return;
	}		 	
    for (i=1;i<=patLen-plen;i++){
		RegNo="0"+RegNo;  
	}
	$('#ByPatNo').val(RegNo);
	var params=RegNo;
	$('#admdg').datagrid({
	url:url+'?action=GetPatInfoByPatno',	
		queryParams:{
			params:params
		}
	});
}

/// ��ѯ
function Query(){
	var params=GetParams();
	$('#warddg').datagrid({
		url:url+'?action=GetPrtWardList',	
		queryParams:{
			params:params
		}
	});
}

///��ȡ���
function GetParams(){
	var WardList="";
	var StDate=$('#DbSt').datebox('getValue');   //��ʼ����
	var EndDate=$('#DBEnd').datebox('getValue'); //��ֹ����
	var checkedItems = $('#warddg').datagrid('getChecked');
	$.each(checkedItems, function(index, item){
		if (WardList==""){
			WardList=item.WardID;
		}else{
			WardList=WardList+","+item.WardID;
		}	 
	}); 
    var LocGrpDr=$('#LocGrpCombo').combobox("getValue"); //������
	var InstId=$('#InstCombo').combobox("getValue"); //�÷�
	if (InstId==0){
		InstId=""
	}
	var params=PhLocDr+"^"+StDate+"^"+EndDate+"^"+WardList+"^"+CurAdm+"^"+LocGrpDr+"^"+InstId;
    var batlist="";  //����
	$("input[type=checkbox][name=batbox]").each(function(){
		if($('#'+this.id).is(':checked')){
		    if (batlist==""){
			   batlist=this.value;
		    }else{
			   batlist=batlist+","+this.value;
		    }
		}
	})
	var prtedflag="";  //�Ѵ�
	$("input[type=checkbox][name=PrtedBox]").each(function(){
		if($('#'+this.id).is(':checked')){
			prtedflag=this.value;
		}
	})
	var params=params+"^"+batlist+"^"+prtedflag;
	return params;
}

/// ��ѯҽ��
function QueryDetail(){
	ClearGrid();
	var params=GetParams();
	$('#ordtimdg').datagrid({
		url:url+'?action=GetPrtWardDetail',	
		queryParams:{
			params:params
		},
		onLoadSuccess: function(){
          	QuerySum();
	    }
	});
}

/// ��ѯҽ��
function QuerySum(){
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		return;
	}
	$('#ordtimsumdg').datagrid({
		url:url+'?action=GetPreStatData',	
		queryParams:{
			params:pid
		}
	});
}

/// ���
function ClearGrid(){
    ClearTMP();
	$('#curlabeldg').datagrid('loadData',{total:0,rows:[]}); 
	$('#ordtimsumdg').datagrid('loadData',{total:0,rows:[]}); 
	//$('#ordtimdg').datagrid('loadData',{total:0,rows:[]}); 
	$('#CWard').val(''); //�ǼǺ�
	$('#CBed').val(''); //�������� 
	$('#CName').val('');
	$('#CSex').val('');
	$('#CAge').val('');
	$('#CWeight').val('');
	$('#CPatId').val('');
    $('#CDosDate').val('');
}

/// ��ȡ��ǰǩ��Ϣ
function GetCurBatInfo(MDsp){
	/// ��ȡ��Ϣ
	$.ajax({
		type: "POST",
		url: url,
		data: "action=GetCurBatInfo&Input="+MDsp,
		//dataType: "json",
		success: function(val){
			var tmp=val.split("^");
			$('#CWard').val(tmp[0]); //�ǼǺ�
			$('#CBed').val(tmp[1]); //�������� 
			$('#CName').val(tmp[2]);
			$('#CSex').val(tmp[3]);
			$('#CAge').val(tmp[4]);
			$('#CWeight').val(tmp[5]);
			$('#CPatId').val(tmp[6]);
			$('#CDosDate').val(tmp[7]);
		}
	})
	$('#curlabeldg').datagrid({
		url:url+'?action=GetCurPatBatDs',	
		queryParams:{
			params:MDsp
		}
	});	
}

/// �����ʱglobal
function ClearTMP(){
	if (CurKFlag=="0"){
		CurKFlag="";
		return;
	}	
	var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		return;
	}
	var ret = tkMakeServerCall("web.DHCSTPIVAPRTLABEL", "ClearTMP",pid);
}

/// ��ӡ��ǩ
function SaveDisp(){
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		$.messager.alert('��ʾ', 'û������!', 'info'); 
		return;
	}
	if($('#PrtedBox').is(':checked')){
		$.messager.alert('��ʾ', '�����ǩ�������Һ�ۺϲ�ѯ����!', 'info'); 
		return;
	}
	$.messager.confirm('ȷ�϶Ի���', 'ȷ����ӡ��', function(r){
	  if (r){
		  ExeSave();
	    }
    });
}

/// ִ�д�ӡ
function ExeSave(){
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	var prtedflag="";  //�Ѵ�
	var arrChk=$("input[name='PrtedBox'][checked]");
	$(arrChk).each(function(){
	    prtedflag=this.value;	   
	});
    if (prtedflag=="Y"){
		var phac = tkMakeServerCall("web.DHCSTPIVAPRTLABEL", "GetPhacForRePrt",pid);
    }else{
		var input=pid+"^"+UserDr;
		var phac = tkMakeServerCall("web.DHCSTPIVAPRTLABEL", "SaveDisp",input);	
		QueryDetail();
	}
	if (phac!=""){
		PrintLabelDetail(phac);		
	}
}
/// ��ӡ��ϸ
function PrintLabelDetail(phac){
    var Hospname=tkMakeServerCall("web.DHCSTKUTIL","HospName");
    var retstr=tkMakeServerCall("web.DHCSTPIVAPRTLABEL","GetPrintItm",phac);
    if (retstr=="") return;
    var vstr=retstr.split("^")
    if (vstr.length<1) return;
    var pid=vstr[0]
    var pognums=vstr[1]
    if (pognums==0) return;
    if (pid=="") return;
    var i,j;
    var Bar=new ActiveXObject("DHCSTPrint.PIVALabel");
    for (i=1;i<=pognums;i++){
	    var pogstr=tkMakeServerCall("web.DHCSTPIVAPRINTLABEL","GetPogList",pid,i)
	    if (pogstr=="") return;
	    var pogistr=tkMakeServerCall("web.DHCSTPIVAPRINTLABEL","GetPogItmList",pid,i)
	    if (pogistr=="") return;
	    Bar.Device="PIVA";
	    Bar.PageWidth=65;
		Bar.PageHeight=90;
		Bar.HeadFontSize=12;
		Bar.FontSize=10;
		Bar.Title=Hospname+"��Һ��";
		Bar.HeadType="";
		Bar.IfPrintBar="true";
		Bar.BarFontSize=25;
		Bar.BarTop=5;
		Bar.BarLeftMarg=67;
		Bar.PageSpaceItm=2;
		Bar.ItmFontSize=10;
		Bar.ItmCharNums=30; //ҩ��ÿ����ʾ���ַ���
		Bar.ItmOmit="false";	//ҩƷ�����Ƿ�ȡ��ֻ��ӡһ��
		Bar.PageMainStr=pogstr;	// ��ӡ��ǩҽ����Ϣ
		Bar.PageItmStr=pogistr;	// ��ӡ��ǩҩƷ��Ϣ
		Bar.PageLeftMargine=1;
		Bar.PageSpace = 1;
		Bar.BarWidth=14;
		Bar.BarHeight=14;
		//Bar.PageSpace = 1;
		if(i==pognums){
			Bar.PrintDPage("1");
		}else{
			Bar.PrintDPage("0");
		}	
    }
    return pid;
 }
//���
function btnPackHandler(){
	UpdatePogFlag("P")
}
//ȡ�����
function btnCancelPackHandler(){
	UpdatePogFlag("N")
}
function UpdatePogFlag(pogflag){
	var selecteddata = $('#ordtimdg').datagrid('getSelected');
	var selectedrow=$('#ordtimdg').datagrid("getRowIndex",selecteddata);
	if (selecteddata==null){
		$.messager.alert("��ʾ","����ѡ������!");
		return;
	}
	var dspstr=selecteddata["TbDspStr"];
	var tbpogstate=selecteddata["TbPackState"];
	var tmppogdesc=""
	if (pogflag=="P"){
		if (tbpogstate.indexOf("���")>0){
			$.messager.alert("��ʾ","��ǰΪ"+tbpogstate+"״̬,�����ٴδ��!");
			return;
		}
		tmppogdesc="������"
	}else if(pogflag=="N"){
		if (tbpogstate==""){
			$.messager.alert("��ʾ","��ǰΪδ���״̬,����ȡ��!");
			return;
		}else if (tbpogstate=="��ʿ���"){
			$.messager.alert("��ʾ","��ǰΪ��ʿ���״̬,����ȡ���뻤ʿ��¼ϵͳ����!");
			return;
		}else if (tbpogstate=="���δ��"){
			$.messager.alert("��ʾ","��ǰΪ���δ��״̬,����ȡ���뻤ʿ��¼ϵͳ����!");
			return;
		}	
	}
	var packret=tkMakeServerCall("web.DHCSTPIVAPRTLABEL","UpdPogFlag",dspstr,pogflag); //���ݴ������id����	
	if (packret=="0"){
		if (pogflag=="P"){			
			$.messager.alert("��ʾ","����ɹ�!");
		}else if(pogflag=="N"){
			$.messager.alert("��ʾ","ȡ������ɹ�!");	
		}
		$('#ordtimdg').datagrid('updateRow',{
			index: selectedrow,
			row: {TbPackState:tmppogdesc}
		})
	}else{
		$.messager.alert("��ʾ",packret);
	}
}
//ˢ��tab
function RefTab(){
	$('#admdg').datagrid({
		url:url+'?action=GetPatInfoByPatno',	
		queryParams:{
			params:''
		}
	});
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		pid="-9"
	}
	$('#ordtimsumdg').datagrid({
		url:url+'?action=GetPreStatData',	
		queryParams:{
			params:pid
		}
	});
}