/**
 * ģ��:��������
 * createdate:2015-12-05
 * creator:LiangQiang
 * scripts/dhcpha/piva/DHCST.PIVA.BATUPDATE.js
 */
var url = "DHCST.PIVA.ACTION.csp";
var PhLocDr=session['LOGON.CTLOCID'];
var UserDr=session['LOGON.USERID'];
var CurWardID="";
var CurAdm="";
var CurKFlag=""; // �Ƿ����
var currEditRow="";currEditID=""
var serBatNoEditor;
$(function(){
	InitDateBox();
	initPhaLocGrp();
	InitWardList();
	InitPatNoList();
	InitOrdItmdgList();
	InitCurLabel();
	InitAllLabel();
	InitPhaLocBatBox(PhLocDr);
	$('#btnFind').bind("click",Query);  // �����ѯ
    $('#btnOk').bind("click",UpdBatData);
    $('#ByPatNo').bind('keypress',function(event){
        if(event.keyCode == "13"){
            GetPatAdmList(); // ���ò�ѯ
        }
    });
    $(".tabs-header").bind('click',function(){
		RefTab();
		CurKFlag=0; // ���Ʋ�ˢ��		
	})
	//�뿪
	window.onbeforeunload = function(){
		ClearTMP();
	};
});

function InitDateBox(){
	$("#DbSt").datebox("setValue", formatDate(0));  //Init��ʼ����
	$("#DBEnd").datebox("setValue", formatDate(0));  //Init��������	
}

//��ʼ��ҩ��������
function initPhaLocGrp(){
	$('#LocGrpCombo').combobox({  
		panelWidth: 200,
		url:url+'?action=GetLocListByGrp&Input='+PhLocDr,  
		valueField:'rowId',  
		textField:'Desc',
		onLoadSuccess: function(){
			var data = $('#LocGrpCombo').combobox('getData');
            if (data.length > 0) {
                 // $('#LocGrpCombo').combobox('select', data[0].rowId);
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

//��ʼ�������б�
function InitWardList(){
	//����columns
	var columns=[[
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
		pageSize:100,  // ÿҳ��ʾ�ļ�¼����
		pageList:[100],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		//pagination:true,
	    onClickRow:function(rowIndex,rowData){
		   CurWardID=rowData.WardID;
		   CurAdm="";
		   QueryDetail();
	   }
	});
    //initScroll("#warddg");
}
function InitPatNoList(){
	//����columns
	var columnspat=[[
		{field:'Adm',title:'adm',hidden:true},
		{field:'AdmDate',title:'��������',width:100},
		{field:'AdmTime',title:'����ʱ��',width:100},
		{field:'AdmLoc',title:'�������',width:100},
		{field:'CurrWard',title:'����',width:100},
		{field:'CurrWardID',title:'����ID',width:100},
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

function InitOrditmDatagrid()
{

	 //����
	 serBatNoEditor={  //������Ϊ�ɱ༭
		type: 'combobox', //���ñ༭��ʽ
		options: {
			//required: true, //���ñ༭��������
			panelHeight:"auto",
			valueField: "text",  //yunhaibao20160318,һ���ò�������id
			textField: "text",
			url:url+'?action=GetLocBatNoCombo&Input='+PhLocDr,
			onSelect:function(option){
					if(currEditID != ""){
						var rows=$('#'+currEditID).datagrid('getRows');//��ȡ���е�ǰ���ص�������
						lastbatno=rows[currEditRow].TbBatNo;
						dsp=rows[currEditRow].TbMDsp;
					}

					$.messager.confirm('ȷ�϶Ի���', 'ȷ��Ҫ�޸���', function(r){
					  if (r){
					  		var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'TbBatNoId'});
							$(ed.target).val(option.value);  //����ID
							var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'TbBatNo'});
							$(ed.target).combobox('setValue', option.text);  //����Desc

							var ret= tkMakeServerCall("web.DHCSTPIVABATUPDATE","UpdCurBatNo",UserDr,PhLocDr,dsp,option.text);
							if (ret<0) { $(batno.target).val(Currbat);}
						}
						else{
						    var ed=$('#'+currEditID).datagrid('getEditor',{index:currEditRow,field:'TbBatNo'});
						    $(ed.target).combobox('setValue', lastbatno);  //����Desc

						}
					});
			},
			onBeforeLoad: function(param){

			}
		}

	}

}

//ҽ����ϸ�б�
function InitOrdItmdgList(){	
	InitOrditmDatagrid();
	//����columns
	var columnspat=[[		
        {field:"TbSttD",title:'��ҩʱ��',width:140},
		{field:'TbBatNo',title:'����',width:50,editor:serBatNoEditor},
		{field:'TbBatNoId',title:'����id',editor:'text',hidden:true},
		{field:"TbMDsp",title:'TbMDsp',hidden:true},
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
		{field:"TbPatNo",title:'�ǼǺ�',width:85},
		{field:'TbAdmcolor',title:'��ɫ',width:50,hidden:true},
		{field:'TbPID',title:'PID',width:50,hidden:true}
	]];
	                                                          
	//����datagrid
	$('#ordtimdg').datagrid({
		url:'',
		fit:true,
		border:false,
		singleSelect:true,
		toolbar:'#orditmgbbar',
		rownumbers:false,  //�ſ������ liangqiang
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
		   var PID=rowData.TbPID;
		   GetCurBatInfo(MDsp);
		   var input=MDsp+"^"+PID
		   GetCurPatBatInfo(input); 
		   if ((currEditRow != "")||(currEditRow == "0")) {
				$("#"+currEditID).datagrid('endEdit', currEditRow);
				var tmpMDspInfo=tkMakeServerCall("web.DHCSTPIVABATUPDATE","GetCurBatInfo",MDsp)
				$('#ordtimdg').datagrid('updateRow',{
					index: rowIndex,
					row: {TbSttD:tmpMDspInfo.split("^")[7]}
				});
			} 
			$("#"+this.id).datagrid('beginEdit', rowIndex);
			currEditID=this.id;
			currEditRow=rowIndex;
	    },
	    onClickCell:function(rowIndex, field, value){
            if (field!="TbBatNo"){
				return;
            }
       }	
	});
	$('#ordtimdg').datagrid('loadData',{total:0,rows:[]}); /// ��ʼ��ҳ��
    //initScroll("#ordtimdg");
}

//��ǰƿǩ
function InitCurLabel()
{
	
	//����columns
	var columnspat=[[
	    {field:'drug',title:'ҩƷ',width:230},
		{field:'dose',title:'����',width:60},
		{field:'freq',title:'Ƶ��',width:50},
		{field:'oeorestat',title:'ִ�м�¼״̬',width:50,hidden:true}
		
	]];
	
	//����datagrid
	$('#curlabeldg').datagrid({
		url:url+'?action=GetCurPatBatDs',
		toolbar:'#curlabeldgbar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		//pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		//pageList:[40,80,120,160],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg:null,
		//loadMsg: '���ڼ�����Ϣ...',
		pagination:false,
		rowStyler: function(index,row){
			if (row.oeorestat=="0"){
				return 'color:#ff0066;font-weight:bold';
			}
		}
	});

	//initScroll("#curlabeldg");
}


//����ƿǩ
function InitAllLabel()
{
	
	//����columns
	var columnspat=[[
		{field:'print',title:'��ӡ',width:30},
		{field:'batno',title:'����',width:50},
	    {field:'incidesc',title:'ҩƷ',width:230},
		{field:'dosage',title:'����',width:60},
		{field:'freq',title:'Ƶ��',width:50},
		{field:'oestatus',title:'ֹͣ',width:50,hidden:true},
		{field:'xdate',title:'ֹͣ����',width:80},
		{field:'xtime',title:'ֹͣʱ��',width:80},
		{field:'xusername',title:'ֹͣ��',width:80},
		{field:'oestatusflag',title:'ֹͣ��־',hidden:true}
		
	]];
	
	//����datagrid
	$('#alllabeldg').datagrid({
		url:'',
		toolbar:'#patnodgBar',
		fit:true,
		rownumbers:true,
		columns:columnspat,
		//pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		//pageList:[40,80,120,160],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:false,
	    onDblClickRow:function(rowIndex,rowData){
			//var pointer=rowData.CurrWardID;
			//QuerySubDb(inputs);
			//var AdmId=rowData.Adm;
			//QueryResult(pointer,AdmId)
		 },
		rowStyler:function(index,row){  
			if (row.oestatusflag==0){  
				return 'background-color:#FFB5C5;';  
			}    
		 }

	});

	//initScroll("#alllabeldg");
}

///��ѯ
function Query()
{
	var params=GetParams();
	$('#warddg').datagrid({
		url:url+'?action=GetAdtWardList',	
		queryParams:{
			params:params}
	});
}

///��ȡ���
function GetParams()
{
	var StDate=$('#DbSt').datebox('getValue');   //��ʼ����
	var EndDate=$('#DBEnd').datebox('getValue'); //��ֹ����
	var params=PhLocDr+"^"+StDate+"^"+EndDate+"^"+CurWardID+"^"+CurAdm;
    var batlist="";  //����

	$("input[type=checkbox][name=batbox]").each(function(){
		if($('#'+this.id).is(':checked')){
		    if (batlist=="")
		    {
			   batlist=this.value;
		    }else{
			   batlist=batlist+","+this.value;
		    }
		}
	})

	var LocGrpId=$('#LocGrpCombo').combobox('getValue');
	
	if ($('#LocGrpCombo').combobox('textbox').val().length==0)
	{
		LocGrpId="";
					 $('#LocGrpCombo').combobox("clear");
					 $('#LocGrpCombo').combobox('setValue', '');
	}
    
	var params=params+"^"+batlist+"^"+LocGrpId;
	return params;
		
}

///��ѯҽ��
function QueryDetail()
{
	ClearGrid();
	var params=GetParams();
	$('#ordtimdg').datagrid({
		url:url+'?action=GetAdtWardDetail',	
		queryParams:{
			params:params}
	});


}

//���
function ClearGrid()
{
	ClearTMP(); 
	$('#CWard').val(''); //�ǼǺ�
	$('#CBed').val(''); //�������� 
	$('#CName').val('');
	$('#CSex').val('');
	$('#CAge').val('');
	$('#CWeight').val('');
	$('#CPatId').val('');
    $('#CDosDate').val('');
    $('#curlabeldg').datagrid('options').queryParams.params = "";  
    $('#alllabeldg').datagrid('options').queryParams.params = "";  
	$('#curlabeldg').datagrid('loadData',{total:0,rows:[]}); 
    $('#alllabeldg').datagrid('loadData',{total:0,rows:[]});
}
//��ȡ��ǰǩ��Ϣ
function GetCurBatInfo(MDsp){

	//��ȡ��Ϣ
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

    /*
	$('#curlabeldg').datagrid({
		url:url+'?action=GetCurPatBatDs',	
		queryParams:{
			params:MDsp}
	});
	*/
    
	$('#curlabeldg').datagrid('load',  {  
			params:MDsp
    });	
}
///�������б�ǩ��Ϣ
function GetCurPatBatInfo(params){
	$('#alllabeldg').datagrid({
		url:url+'?action=GetCurPatBatInfo',	
		queryParams:{
			params:params}
	});
}
///���ǼǺŲ�ѯ�����б�
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
	var validnoret=tkMakeServerCall("web.DHCSTKUTIL", "ValidateRegNo",RegNo);
	if (validnoret==""){
		$.messager.alert('��ʾ','�ǼǺ�:'+RegNo+'������!','warning');
		$('#ByPatNo').val("");
		return;
	}
	 $('#ByPatNo').val(RegNo);
	 var params=RegNo;

	 $('#admdg').datagrid({
		url:url+'?action=GetPatInfoByPatno',	
		queryParams:{
			params:params}
	 });

}


//��ȡ��ǰǩ��Ϣ
function InitPhaLocBatBox(PhLocDr){
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=GetPhaLocBatInfo&Input="+PhLocDr,
       //dataType: "json",
       success: function(val){
            var chkhtml="";
			var tmp=val.split("^");			
			for (i=1;i<=tmp.length;i++)
			 {
				 var batstr=tmp[i-1].split(",");
                 var batnoid=i ; //batstr[0];
                 var batnodesc=batstr[1];
				 //alert(batnoid)
				 
				 var tmphtml='<span style="margin-left:10px;"><input style="vertical-align: text-bottom;" id="'+batnoid+'" class="ui-checkbox" name="batbox" type="checkbox" value='+batstr[0]+'>'+batnodesc+'</input></span>'
				 if (chkhtml=="")
				 {
                    chkhtml=tmphtml;
				 }else{
					chkhtml=chkhtml+tmphtml;
				 }
			 }
			$("#DivBatNo").append(chkhtml);
       }
    })
}


//��������
function UpdBatData(){
    var pid="";
	var rows = $("#ordtimdg").datagrid("getRows");
    for(var i=0;i<rows.length;i++){
		var pid=rows[i].TbPID ;
		break;
	}
	if (pid==""){
		return;
	}
    var input=pid+"^"+UserDr;
	$.ajax({
   	   type: "POST",
       url: url,
       data: "action=UpdBatData&Input="+input,
       //dataType: "json",
       success: function(val){
            QueryDetail();
       }
    })
}

//�����ʱglobal
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
	var ret = tkMakeServerCall("web.DHCSTPIVABATUPDATE", "ClearTMP",pid);
}

//ˢ��tab
function RefTab(){
	$('#admdg').datagrid({
		url:url+'?action=GetPatInfoByPatno',	
		queryParams:{
			params:''}
	});
}