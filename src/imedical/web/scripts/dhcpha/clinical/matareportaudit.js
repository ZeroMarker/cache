// Creator: congyue
/// CreateDate: 2015-11-09
//  Descript: ������Ӧ��ѯ

var url = "dhcadv.repaction.csp";
var statArray = [{ "val": "�", "text": "�" },{ "val": "ȷ��", "text": "ȷ��" },{ "val": "���", "text": "���" }, { "val": "���", "text": "���" }];
var statReceive = [{ "val": "δ����", "text": "δ����" },{ "val": "1", "text": "����" },{ "val": "2", "text": "����" }];
var statShare = [{ "val": "δ����", "text": "δ����" },{ "val": "����", "text": "����" }];
var editRow="",TranFlag=0,errflag=0 ;///TranFlag:ת����־   errflag:ת���ظ���Ա�뱻ת����Ա�Ƿ�һ��
document.write('<script type="text/javascript" src="../scripts/dhcadvEvt/dhcadvExpPri.js"></script>');
$(function(){

	$("#stdate").datebox("setValue", formatDate(-2));  //Init��ʼ����
	$("#enddate").datebox("setValue", formatDate(0));  //Init��������
	
 	/* ���� */
	var DeptCombobox = new ListCombobox("dept",url+'?action=SelAllLoc','',{});
	DeptCombobox.init();

	/* ״̬ */
	var StatusCombobox = new ListCombobox("status",'',statArray,{panelHeight:"auto"});
	StatusCombobox.init();

	/* �������� */
	var TypeeventCombobox = new ListCombobox("typeevent",url+'?action=selEvent','',{});
	TypeeventCombobox.init();
	
	/* ����״̬ */  
	var ReceiveCombobox = new ListCombobox("receive",'',statReceive,{panelHeight:"auto"});
	ReceiveCombobox.init();
	
	/* ����״̬ */  
	var ShareCombobox = new ListCombobox("Share",'',statShare,{panelHeight:"auto"});
	ShareCombobox.init();
	
	$('#Find').bind("click",Query);  //�����ѯ
	$('#audit').bind("click",Process); //����
	$('#Audit').bind("click",Audit); //ȷ������
	$('#REceive').bind("click",REceive); //����
	$('#back').bind("click",Back); //���沵��
	$('#RepImpFlag').bind("click",RepImpFlag); //�ص��ע
	$('#SHare').bind("click",Share); //����״̬  RepShareFlag
	$('#export').bind("click",Export); 	  //����
	$('a:contains("��ӡ")').bind("click",Print);     //��ӡ
	$('#Transcription').bind("click",Transcription); //ת������
	$('#exportAudit').bind("click",ExportAudit); 	  //��˵���
	
	InitRepList(); //��ʼ�������б�
	
	//�ǼǺŻس��¼�
	$('#patno').bind('keypress',function(event){
	 if(event.keyCode == "13"){
		 var patno=$.trim($("#patno").val());
		 if (patno!=""){
			GetWholePatID(patno);
			Query();
		 }	
	 }
	});
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
})

//��ѯ
function Query()
{
	//1�����datagrid 
	$('#maindg').datagrid('loadData', {total:0,rows:[]}); 
	//2����ѯ
	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$('#status').combobox('getValue');  //״̬
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	var receive=$('#receive').combobox('getValue');  //����״̬
	var statShare=$('#Share').combobox('getValue');  //����״̬ 
	if (LocID==undefined){LocID="";}
	if (status==undefined){status="";}
	if (typeevent==undefined){typeevent="";}
	if (receive==undefined){receive="";}
	if (statShare==undefined){statShare="";}
	var PatNo=$.trim($("#patno").val());
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare;
	$('#maindg').datagrid({
		url:url+'?action=QueryMataReport',	
		queryParams:{
			params:params}

	});
}

//ȷ������
function Audit()
{	var NextLoc=$('#matadrNextLoc').combobox('getValue');
	var LocAdvice=$('#matadrLocAdvice').val();
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var ID=item.ID;         //����ID
		var typecode=item.typecode; //�������ʹ���
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var params=ID+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode;   //������
		//alert(params);
		//��������
		$.post(url+'?action=AuditMataReport',{"params":params},function(jsonString){
			var resobj = jQuery.parseJSON(jsonString);
			if(resobj.ErrCode < 0){
				$.messager.alert("��ʾ:","<font style='font-size:20px;'>��˴���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
			}
		});
	})

	$('#maindg').datagrid('reload'); //���¼���
	$('#Process').window('close');
}


//���
function Process()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ������˲���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				$('#Process').window({
					title:'���',
					collapsible:false,
					border:false,
					closed:false,
					width:400,
					height:280
				});
				//ָ�����
				$('#matadrNextLoc').combobox({
					//panelHeight:"auto",  //���������߶��Զ�����
					url:url+'?action=SelAllLoc'
				});  
				$('#Process').window('open'); 
				$("#matadrLocAdvice").empty(); 
			});
		}
	})
}

//����
function REceive()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���н��ղ���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //����ID
				var typecode=item.typecode;         //�������ʹ���
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬
				var StatusID=item.StatusID //��ǰ״̬id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode+"^"+StatusID;   //������
				//alert(params);
				//��������
				$.post(url+'?action=REMataReport',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					if(resobj.ErrCode < 0){
						$.messager.alert("��ʾ:","<font style='font-size:20px;'>���մ���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
					}
				});
			})
			$('#maindg').datagrid('reload'); //���¼���
		}
	})
}
//���沵��
function Back()
{
	var NextLoc="";
	var LocAdvice="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���в��ز���", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //����ID
				var typecode=item.typecode;         //�������ʹ���
				var Medadrreceivedr=item.Medadrreceivedr;//����״̬
				var StatusID=item.StatusID //��ǰ״̬id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+NextLoc+"^"+LocAdvice+"^"+Medadrreceivedr+"^"+typecode+"^"+StatusID;   //������
				//alert(params);
				//��������
				$.post(url+'?action=ReportBack',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					if(resobj.ErrCode < 0){
						$.messager.alert("��ʾ:","<font style='font-size:20px;'>���ش���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
					}
				});
		
			})
			$('#maindg').datagrid('reload'); //���¼���
		}
	})
}


//����
function Share(){
var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���з������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //����ID
				var typecode=item.typecode;         //�������ʹ���
				var RepShareFlag=item.RepShareFlag;//����״̬
				 if(RepShareFlag=="����"){
					$.messager.alert("��ʾ:","�Ѿ�����");
					return;
				}
		
				var StatusID=item.StatusID //��ǰ״̬id
				var params=ID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+typecode+"^"+StatusID+"^"+RepShareFlag   //������
				//alert(params);
				//��������
				$.post(url+'?action=InsRepShare',{"params":params},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
					if(resobj.ErrCode < 0){
						$.messager.alert("��ʾ:","<font style='font-size:20px;'>���մ���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
					}
				});
			})
			$('#maindg').datagrid('reload'); //���¼���
		}
	})
	
	
}

//�ص��ע
function RepImpFlag()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ�����ص��ע����", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //����ID
				var typecode=item.typecode;         //�������ʹ���
			    var RepImpFlag=item.RepImpFlag;    //�ص���
			     if(RepImpFlag=="��ע"){
				     RepImpFlag="Y"
					$.messager.alert("��ʾ:","�Ѿ��ص��ע��");
					return;
				}
			     if(RepImpFlag=="δ��ע"){
				     RepImpFlag="N"
			
				} 
				if(typecode=="drug"){ //ҩƷ
				//��������
				$.post(url+'?action=REPImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
				if(typecode=="blood"){//��Ѫ
				//��������
				$.post(url+'?action=BloodImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
				if(typecode=="med"||typecode=="bldevent"){ //ҽ��
				//��������
				$.post(url+'?action=MedImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
				if(typecode=="material"){//��е
				//��������
				$.post(url+'?action=MaterImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
				if(typecode=="drugerr"){//��ҩ����
				//��������
				$.post(url+'?action=DrugerImpReport',{"ID":ID,"RepImpFlag":RepImpFlag},function(jsonString){
					var resobj = jQuery.parseJSON(jsonString);
				 });
				}
		
			})
			$('#maindg').datagrid('reload'); //���¼���
		}
	})
}


//��ʼ�������б�
function InitRepList()
{
	//����columns   
	var columns=[[
		{field:"ck",checkbox:true,width:20},
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Medadrreceive',title:'����״̬',width:80},
		{field:'Medadrreceivedr',title:'����״̬dr',width:80,hidden:true},
		{field:'RepShareFlag',title:'����״̬',width:100,align:'center'},
		{field:'Edit',title:'�޸�',width:80,align:'center',formatter:setCellEditSymbol,hidden:false},
		{field:'AuditList',title:'������ϸ',width:80,align:'center',formatter:setCellAuditList,hidden:false},
		{field:'RepImpFlag',title:'�ص��ע',width:100,align:'center',formatter:setCellColorOne,hidden:false},
		{field:'CreateDate',title:'��������',width:100},
		{field:'RepNo',title:'������',width:160},
		{field:'PatNo',title:'�ǼǺ�',width:120},
		{field:'PatName',title:'����',width:120},
		{field:'Status',title:'��ǰ״̬',width:100,hidden:false},
		{field:'StatusID',title:'��ǰ״̬ID',width:100,hidden:true},
		{field:'StatusNext',title:'��һ״̬',width:100,hidden:false},
		{field:'StatusNextID',title:'��һ״̬ID',width:100,hidden:true},
		{field:'LocDesc',title:'�������',width:220},
		{field:'Typeevent',title:'��������',width:220},
		{field:'Creator',title:'������',width:120},
		{field:'typecode',title:'�������ʹ���',width:120},
		{field:'Subflag',title:'�ӱ��־',width:120,hidden:true},
		{field:'catDesc',title:'һ������',width:100,hidden:false},
		{field:'armaCatDesc',title:'��������',width:100,hidden:false},
		{field:'armaLevelDesc',title:'�¼��ȼ�',width:100,hidden:false},
	]];
	
	//����datagrid
	$('#maindg').datagrid({
		title:'�����б�',
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		rowStyler:function(index,row){  
	        if (row.Medadrreceivedr==2){  
	            return 'background-color:red;';  
	        }  
    	},
        onSelect:function(rowIndex, rowData){  
			var reportID=rowData.ID;         //����ID
			var typecode=rowData.typecode;         //��������
			var params=reportID+"^"+typecode+"^"+LgUserID;
			var Subflag=rowData.Subflag;
			var SubUserflag=""
	        $.ajax({
				type: "POST",// ����ʽ
		    	url: url,
				async: false, //ͬ��
		    	data: "action=SearchAuditIUser&params="+params,
				success: function(data){
					SubUserflag=data;
				}
			});
			if((Subflag==1)&&(SubUserflag==1)){
				$('#REceive').hide();
				$('#back').hide();
				$('#RepImpFlag').hide();
				$('#SHare').hide();
				$('#audit').hide();
			}else{
				$('#REceive').show();
				$('#back').show();
				$('#RepImpFlag').show();
				$('#SHare').show();
				$('#audit').show();
			}
		}  
	});
	
	initScroll("#maindg");//��ʼ����ʾ���������
}

///���ñ༭����
function setCellEditSymbol(value, rowData, rowIndex)
{
		var ID=rowData.ID;         //����ID
		var typecode=rowData.typecode; //�������ʹ���
		return "<a href='#' onclick=\"showEditWin('"+ID+"','"+typecode+"')\"><img src='../scripts/dhcadvEvt/images/editb.png' border=0/></a>";
}

///������ǰ��ɫ���ص��ע��
function setCellColorOne(value, rowData, rowIndex)
{     
     var RepImpFlag=rowData.RepImpFlag
     if(RepImpFlag=="��ע"){
     
	   return '<span style="color:yellow;">'+value+'</span>';
     }else{
	     
	   return  value;
	 }
}

///������ǰ��ɫ
function setCellColor(value, rowData, rowIndex)
{
	return '<span style="color:red;">'+value+'</span>';;
}

//�༭����
function showEditWin(ID,typecode)
{
	if($('#win').is(":visible")){return;}  //���崦�ڴ�״̬,�˳�

	$('body').append('<div id="win"></div>');
	$('#win').window({
		title:'����༭',
		collapsible:true,
		border:false,
		closed:"true",
		width:1250,
		height:600
	});
	if(typecode=="material"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.matareport.csp?matadrID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="drugerr"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medsafetyreport.csp?medsrID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="blood"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.bloodreport.csp?bldrptID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	
	if(typecode=="med"||typecode=="bldevent"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.medicalreport.csp?adrRepID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}
	if(typecode=="drug"){
		var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcadv.advreport.csp?advdrID='+ID+'&editFlag='+1+'"></iframe>';
		$('#win').html(iframe);
		$('#win').window('open');
	}	
}

///��0���˵ǼǺ�
function GetWholePatID(RegNo)
{
	var len=RegNo.length;
	var  reglen=10
	var zerolen=reglen-len
	var zero=""
	for (var i=1;i<=zerolen;i++)
	{zero=zero+"0" ;
		}
	var RegNo=zero+RegNo ;
	$("#patno").val(RegNo);
}

 
// ����Excel
function Export()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	
	$.messager.confirm("��ʾ", "�Ƿ���е�������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			var filePath=browseFolder();
			alert(filePath)
			if (typeof filePath=="undefined"){
				$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
				return;
			}
			$.each(selItems, function(index, item){
		
				var ID=item.ID;         //����ID
				var typecode=item.typecode; //�������ʹ���
				ExportExcel(ID,typecode,filePath);
			})
	
			$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
		}
	})
}

 /// ��ӡ
function Print(){
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ���д�ӡ����", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			$.each(selItems, function(index, item){
				var ID=item.ID;         //����ID
				var typecode=item.typecode; //�������ʹ���
				printRep(ID,typecode);
			})
		}
	})
}
//ת��  2016-05-13 ����
function Transcription()
{	
	TranFlag=0;
	//��������
	$('#medadrUser').attr("disabled",false);
	$('#medadrDateTime').attr("disabled",false);
	$("#tranLocAdvic").attr("disabled",false);
	$("#medadrUser").val("");
	$("#medadrDateTime").val("");
	$("#tranLocAdvic").val("");
	$("#tranLocDr").combobox('setValue',"");
	$("#tranReplyMess").val("");

	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	if (selItems.length>1){
		$.messager.alert("��ʾ:","ת������,��ֻѡ��һ�����ݣ�");
		return;
	}
	$.messager.confirm("��ʾ", "�Ƿ����ת������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {

			$('#TranWin').window({
				title:'ת��',
				collapsible:false,
				border:false,
				closed:false,
				width:900,
				height:580
			});
			$('#TranWin').window('open');
		}
	})
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //����ID
		var typecode=item.typecode;         //��������
		var params=reportID+"^"+typecode;
		var Subflag=item.Subflag;         //�ӱ��־
		
		TranUserList(reportID,typecode,Subflag);//ת��ָ����Ա
		TranLocUserList(reportID,typecode,Subflag);//ת��������Ա�����Ϣ
		
		if(Subflag==0){
			//��������
			$('#medadrUser').attr("disabled",false);
			$('#medadrDateTime').attr("disabled",false);
			$("#tranLocAdvic").attr("disabled",false);
			$("#medadrUser").val("");
			$("#medadrUser").attr("disabled",true);
			$("#medadrDateTime").val("");
			$("#medadrDateTime").attr("disabled",true);
			$("#tranLocAdvic").val("");
			$("#tranLocDr").combobox('setValue',"");
			$("#tranReplyMess").val("");
			$("#tranReplyMess").attr("disabled",true);
		}
		$.ajax({
			type: "POST",// ����ʽ
	    	url: url,
	    	data: "action=SearchAuditMess&params="+params,
			success: function(data){
				var tmp=data.split("^");
				if(Subflag==1){
					$('#medadrUser').val(tmp[0]); //������Ա
					$('#medadrUser').attr("disabled","true");
					$('#medadrDateTime').val(tmp[1]+" "+tmp[2]);   //����ʱ��
					$('#medadrDateTime').attr("disabled","true");
					$('#tranLocAdvic').val(tmp[3]); //�������
					$('#tranLocAdvic').attr("disabled","true");
					//var UserID=rowData.UserID;
					if (tmp[5]!=LgUserID){
						errflag=1;
						$("#tranLocDr").combobox('setValue',"");
					}else{
						errflag=0;
					}
		
				}
				else{
					errflag=0;
				}
			}
		});
		if(Subflag==1){
			$('#transub').hide();
			$('#tranreply').show();
			$('#tranrec').show();
	
		}else{
			$('#transub').show();
			$('#tranreply').hide();
			$('#tranrec').hide();
	    }
   });
	
}
//ת��ָ����Ա
function TranUserList(reportID,typecode,Subflag)
{
	//ת������
	$('#tranLocDr').combobox({
		url:url+'?action=SelAllLoc',
		onSelect:function(){
			var tranLocDr=$('#tranLocDr').combobox('getValue');
			var params=typecode+"^"+tranLocDr;
			$('#selectdg').datagrid({
				url:url+'?action=GetUserDr',	
				queryParams:{
					params:params}
			});
		}
	}); 
	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"LocID",title:'LocID',width:90,hidden:true},
		{field:"Locname",title:'Locname',width:90,hidden:true},
		{field:"UserID",title:'UserID',width:90,hidden:true},
		{field:'Username',title:'������Ա',width:120}
	]];
	var titleNotes="";
	if(Subflag==1){
		titleNotes="";
	}else{
		titleNotes='<span style="font-size:10pt;font-family:���Ŀ���;color:red;">[˫���м��������ת�����ݱ�]</span>';
	}
	//����datagrid
	$('#selectdg').datagrid({
		title:'ָ����Ա'+titleNotes,
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		border:false,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){ 
			if((Subflag==1)||(TranFlag==1)){
				$('#selectdg').datagrid({title:'ָ����Ա'});
				return;
			}else{
				$('#selectdg').datagrid({title:'ָ����Ա'+titleNotes});
				if ((editRow != "")||(editRow == "0")) {
	            	$("#selectdg").datagrid('endEdit', editRow);
				}
				var LocID=rowData.LocID;
				var UserID=rowData.UserID;
				var Username=rowData.Username;
			
				var tranLocDr=$('#tranLocDr').combobox('getValue');
				var tranLocDesc=$('#tranLocDr').combobox('getText');
				$('#tranmesdg').datagrid('insertRow',{
					 index: 0,	// index start with 0
					 row: {
						ID:"",
						name: Username,
						nameID: UserID,
						LocDesc: tranLocDesc,
						LocDr: tranLocDr
					}
		        });
		    }
		}
     
	});
	var params=reportID+"^"+typecode;
	$('#selectdg').datagrid({
		url:url+'?action=QueryUserMess',
		queryParams:{
			params:params}
	});
}
//ת��������Ա�����Ϣ
function TranLocUserList(reportID,typecode,Subflag)
{
	//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:"tranDateTime",title:'ת��ʱ��',width:90,hidden:true},
		{field:'tranuser',title:'ת����',width:120,hidden:true},
		{field:"tranuserID",title:'tranuserID',width:90,hidden:true},
		{field:'LocDesc',title:'����',width:120},
		{field:"LocDr",title:'LocDr',width:90,hidden:true},
		{field:'name',title:'��Ա',width:120},
		{field:"nameID",title:'nameID',width:90,hidden:true},
		{field:'advice',title:'��Ա���',width:300},
		{field:"tranreceive",title:'����״̬',width:90,hidden:true},
		{field:"tranrecedate",title:'��������',width:90,hidden:true},
		{field:"trancompdate",title:'�������',width:90,hidden:true}
	]];
	var titleOpNotes="";
	if(Subflag==1){
		titleOpNotes="";
	}else{
		titleOpNotes='<span style="font-size:10pt;font-family:���Ŀ���;color:red;">[˫���м��������������]</span>';
	}
	//����datagrid
	$('#tranmesdg').datagrid({
		title:'ת����Ϣ��'+titleOpNotes,
		url:'',
		fit:true,
		border:false,
		rownumbers:true,
		columns:columns,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
        nowrap:false,
		onDblClickRow:function(rowIndex, rowData){  //˫�����ѡ����
			if((Subflag==1)||(TranFlag==1)){
				return;
			}else{
				$('#tranmesdg').datagrid('deleteRow',rowIndex);
			}
		}
	});
	var params=reportID+"^"+typecode;
	$('#tranmesdg').datagrid({
		url:url+'?action=QueryTranLocUser',	
		queryParams:{
			params:params}
	});
}
//ת���ύ
function TranSub()
{
	if(TranFlag==1){
		$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
		return;
	}
	if(errflag==1){
		$.messager.alert("��ʾ:","��ת����ָ����Ա����Ȩ�޲���");
		return;
	}
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	var mediReceive="",mediRecDate="",mediRecTime="",mediCompleteDate="",mediCompleteTime="",medadrList="";	
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //����ID
		var typecode=item.typecode; //�������ʹ���
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var StatusID=item.StatusID //��ǰ״̬
		medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID+"^"+LgUserID+"^"+LgCtLocID+"^"+LgGroupID+"^"+StatusID;   //������
	})		
	var rows = $("#tranmesdg").datagrid('getRows');
	if(rows.length<=0){
		$.messager.alert("��ʾ","û�д���������!");
		return;
	}
	var dataList = [];
	for(var i=0;i<rows.length;i++)
	{
		if((rows[i].LocDr=="")||(rows[i].nameID=="")){
			$.messager.alert("��ʾ","����ָ�����Ա����Ϊ��!"); 
			return false;
		}
		if(tranLocAdvic==""){
			$.messager.alert("��ʾ","�����������Ϊ��!"); 
			return false;
		}
		var List=rows[i].ID+"^"+LgUserID+"^"+rows[i].LocDr+"^"+rows[i].nameID+"^"+tranReplyMess+"^"+mediReceive+"^"+mediRecDate+"^"+mediRecTime+"^"+mediCompleteDate+"^"+mediCompleteTime+"^"+tranLocAdvic;
		dataList.push(List);
	} 
	var medadriList=dataList.join("&&");
	var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	//alert(params);
	//��������
	$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			TranFlag=1;
			$.messager.alert("��ʾ:","�ύ�ɹ�");
			$('#maindg').datagrid('reload'); //���¼���
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("��ʾ:","<font style='font-size:20px;'>ת���ύ����,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
			return ;
		}
		$('#selectdg').datagrid('reload'); //���¼���
		$('#tranmesdg').datagrid('reload'); //���¼���
		
	});
			
}
//ת���ظ�
function TranReply(Replyflag)
{
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess=$('#tranReplyMess').val();
	var medadriList=LgUserID+"^"+tranReplyMess+"^"+Replyflag;
	if((TranFlag==1)&(Replyflag==1)){
		$.messager.alert("��ʾ:","���ύ�ɹ��������ظ����");
		return;
	}
	if((TranFlag==2)&(Replyflag==0)){
		$.messager.alert("��ʾ:","�ѽ��ճɹ��������ظ����");
		return;
	}
	if((TranFlag==1)&(Replyflag==0)){
		$.messager.alert("��ʾ:","�ظ����ύ��������Ч");
		return;
	}
	if(errflag==1){
		$.messager.alert("��ʾ:","��ת����ָ����Ա����Ȩ�޲���");
		return;
	}
	if((Replyflag==1)&(tranReplyMess=="")){
		$.messager.alert("��ʾ:","�ظ��ύ�������ظ����ݲ���Ϊ��");
		return;
	}
	if((Replyflag==0)&(tranReplyMess!="")){
		$.messager.alert("��ʾ:","���ղ������ظ����ݲ���");
		return;
	}
	var selItems = $('#maindg').datagrid('getSelections');
	var medadrList="";
	if (!selItems.length){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //����ID
		var typecode=item.typecode; //�������ʹ���
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var StatusNextID=item.StatusNextID; //��һ��״̬
		medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //������
		//var params="medadrList="+medadrList+"&medadriList="+medadriList; 
	})
	//alert(params);
	//��������
	$.post(url+'?action=SaveReplyMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
		var resobj = jQuery.parseJSON(jsonString);
		if(resobj.ErrCode==0){
			if(Replyflag==0){
				TranFlag=2;
			}
			if(Replyflag==1){
				TranFlag=1;
				$('#maindg').datagrid('reload'); //���¼���
			}
			$.messager.alert("��ʾ:","�����ɹ�");
		}
		if(resobj.ErrCode < 0){
			$.messager.alert("��ʾ:","<font style='font-size:20px;'>��������,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
		}
		$('#selectdg').datagrid('reload'); //���¼���
		$('#tranmesdg').datagrid('reload'); //���¼���
		
	});
		
}
/* //ת������
function TranRec()
{
	var tranLocDr=$('#tranLocDr').combobox('getValue');
	var tranLocAdvic=$('#tranLocAdvic').val();
	var tranReplyMess="";
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems){
		$.messager.alert("��ʾ:","��ѡ����,���ԣ�");
		return;
	}
	$.each(selItems, function(index, item){
		var reportID=item.ID;         //����ID
		var typecode=item.typecode; //�������ʹ���
		var Medadrreceivedr=item.Medadrreceivedr;//����״̬
		var StatusNextID=item.StatusNextID; //��һ��״̬
		var medadrList=reportID+"^"+typecode+"^"+tranLocDr+"^"+tranLocAdvic+"^"+Medadrreceivedr+"^"+StatusNextID;   //������
		var medadriList=LgUserID+"^"+tranReplyMess;
		var params="medadrList="+medadrList+"&medadriList="+medadriList; 
		//��������
		$.post(url+'?action=SaveTranMess',{"medadrList":medadrList,"medadriList":medadriList},function(jsonString){
			var resobj = jQuery.parseJSON(jsonString);
			if(resobj.ErrCode==0){
				$.messager.alert("��ʾ:","���ճɹ�");
			}
			if(resobj.ErrCode < 0){
				$.messager.alert("��ʾ:","<font style='font-size:20px;'>���մ���,����ԭ��:</font><font style='font-size:20px;color:red;'>"+resobj.ErrMsg+"</font>");
			}
		});
	})	
} */

///����������ϸ����  2016-05-31
function setCellAuditList(value, rowData, rowIndex)
{
		var ID=rowData.ID;         //����ID
		var typecode=rowData.typecode; //�������ʹ���
		return "<a href='#' onclick=\"showAuditListWin('"+ID+"','"+typecode+"')\"><img src='../scripts/dhcadvEvt/images/viewlist.png' border=0/></a>";
}
//�༭����
function showAuditListWin(ID,typecode)
{
	$('#Auditwin').window({
		title:'������ϸ',
		collapsible:true,
		border:false,
		closed:"true",
		width:900,
		height:500
	});
	var columns=[[
		{field:'Status',title:'����״̬',width:80},
		{field:'StatusDR',title:'����״̬ID',width:100,hidden:true},
		{field:'AuditUser',title:'������',width:100},
		{field:'AuditUserDR',title:'������ID',width:100,hidden:true},
		{field:'AuditDateTime',title:'��������',width:150},
		{field:'NextLoc',title:'����ָ��',width:150},
		{field:'NextLocDR',title:'����ָ��ID',width:100,hidden:true},
		{field:'LocAdvice',title:'�������',width:200},
		{field:'Receive',title:'����״̬',width:60},
		{field:'Subflag',title:'Subflag',width:60,hidden:true},
		{field:'ID',title:'ID',width:50,hidden:true} 
	]]; 
	
	// ����columns
	var itmcolumns=[[
		{field:'MedIAuditDateTime',title:'��������',width:150},
		{field:'MedIAuditUser',title:'������',width:100},
		{field:'MedIAuditUserDR',title:'������ID',width:100,hidden:true},
		{field:'MedINextLoc',title:'ָ�����',width:150},
		{field:'MedINextLocDR',title:'����ָ��ID',width:100,hidden:true},
		{field:'MedILocAdvice',title:'�������',width:200},
		{field:'MedINextUser',title:'ָ����Ա',width:100},
		{field:'MedINextUserDR',title:'ָ����ԱID',width:100,hidden:true},
		{field:'MedIUserAdvice',title:'��Ա���',width:200},
		{field:'MedIReceive',title:'����״̬',width:60},
		{field:'MedIReceiveDateTime',title:'��������',width:150},
		{field:'MedICompleteDateTime',title:'�������',width:150}
	]];
	var params=ID+"^"+typecode;
	//����datagrid
	$('#AuditListdg').datagrid({
		url:url+'?action=QueryAuditMess&params='+params,
		fit:true,
		rownumbers:true,
		columns:columns,
		//fitColumns:true,
		pageSize:40,  // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:false,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
        view: detailview,
        subGrid: true,
        nowrap:false,
        detailFormatter:function(index,rowData){
	         if(rowData.Subflag==0) return "";
             return '<div style="padding:0px"><table class="AuditItmListdg"></table></div>';
        },
        onExpandRow:function(index,rowData){
          	var AuditID=rowData.ID;
            var Subflag=rowData.Subflag;
            if(Subflag==0){
	         	return;   
	         }
            if (Subflag==1){
            var AuditItmListdg = $(this).datagrid('getRowDetail',index).find('table.AuditItmListdg');
            AuditItmListdg.datagrid({
				url:url+'?action=QueryAudItmMess&params='+AuditID,
				columns:itmcolumns,
                singleSelect:false,
                rownumbers:true,
				loadMsg: '���ڼ�����Ϣ...',
                height:'auto',
                nowrap:false,
		        onResize:function(){
                    $('#AuditListdg').datagrid('fixDetailRowHeight',index);
                },
                onLoadSuccess:function(){
					setTimeout(function(){
						$('#AuditListdg').datagrid('fixDetailRowHeight',index);
                    },0);
                }
            });
            $('#AuditListdg').datagrid('fixDetailRowHeight',index);
	      } 
        },
        onLoadSuccess:function(data){
			var me = this;
			$(me).parent().find('span.datagrid-row-expander').trigger('click'); //ûЧ��ע���޸������ѡ����
		}
	});
	$('#Auditwin').window('open');
	
}

// ��˵���
function ExportAudit()
{
	var selItems = $('#maindg').datagrid('getSelections');
	if (!selItems.length){
		$.messager.alert('��ʾ',"<font style='color:red;font-weight:bold;font-size:20px;'>����ѡ��һ�м�¼!</font>","error");
		return;
	}
	
	$.messager.confirm("��ʾ", "�Ƿ������˵�������", function (res) {//��ʾ�Ƿ�ɾ��
		if (res) {
			var filePath=browseFolder();
			if (typeof filePath=="undefined"){
				$.messager.alert("��ʾ:","<font style='color:red;font-weight:bold;font-size:20px;'>��ѡ��·����,���ԣ�</font>","error");
				return;
			}
			//$.each(selItems, function(index, item){
		
				//var ID=item.ID;         //����ID
				//var typecode=item.typecode; //�������ʹ���
				ExportExcelAudit(filePath);
			//})
	
			$.messager.alert("��ʾ:","<font style='color:green;font-weight:bold;font-size:20px;'>������ɣ�����Ŀ¼Ϊ:"+filePath+"</font>","info");
		}
	})
}

// ��˵���Excel
function ExportExcelAudit(filePath)
{
	alert(filePath)
/* 	if(ID==""){
		$.messager.alert("��ʾ:","����IDΪ�գ�");
		return;
	}
	
 */  
       //��ȡϵͳ������
    var now = new Date();
    var year = now.getFullYear();       //��
    var month = now.getMonth() + 1;     //��
    if(month<=9){
	    month="0"+month
	} 
    var day = now.getDate();            //��
    if(day<=9){
     day="0"+day
    } 
    var  yearDate=year+""+month+""+day
   	var StDate=$('#stdate').datebox('getValue');   //��ʼ����
	var EndDate=$('#enddate').datebox('getValue'); //��ֹ����
	var LocID=$('#dept').combobox('getValue');     //����ID
	var status=$('#status').combobox('getValue');  //״̬
	var typeevent=$('#typeevent').combobox('getValue');  //��������
	var receive=$('#receive').combobox('getValue');  //����״̬
	var statShare=$('#Share').combobox('getValue');  //����״̬ 
	if (LocID==undefined){LocID="";}
	if (status==undefined){status="";}
	if (typeevent==undefined){typeevent="";}
	if (receive==undefined){receive="";}
	if (statShare==undefined){statShare="";}
	var PatNo=$.trim($("#patno").val());
	
	var params=StDate+"^"+EndDate+"^"+LocID+"^"+PatNo+"^"+LgGroupID+"^"+LgCtLocID+"^"+LgUserID+"^"+status+"^"+typeevent+"^"+receive+"^"+statShare;
	  alert(params)
		var retval=tkMakeServerCall("web.DHCADVSEARCHREPORT","QueryMataRepExport",params);
		if(retval==""){
			$.messager.alert("��ʾ:","ȡ���ݴ���");
			return;
		 }
		 
		var path=tkMakeServerCall("web.DHCDocConfig","GetPath");
		var Template = path+"DHCADV_AuditReport.xls";
		var xlApp = new ActiveXObject("Excel.Application");
		var xlBook = xlApp.Workbooks.Add(Template);
		var objSheet = xlBook.ActiveSheet;
		//xlApp.Range(objSheet.Cells(2,1),objSheet.Cells(2,16)).Interior.Pattern = 2; //�б���ⱳ����ɫ  
	    var auditRepItmArr=retval.split("&&");
	    for(var k=0;k<auditRepItmArr.length;k++){
			var auditArr=auditRepItmArr[k].split("^");
			var auditArr=auditRepItmArr[k].split("^");
			objSheet.Cells(3+k,1).value=auditArr[1]; //�ϱ�����
			objSheet.Cells(3+k,2).value=auditArr[2]; //�ϱ�����
			objSheet.Cells(3+k,3).value=auditArr[3]; //������
			objSheet.Cells(3+k,4).value=auditArr[4]; //��������
			objSheet.Cells(3+k,5).value=auditArr[17]; //�����Ա�
			objSheet.Cells(3+k,6).value=auditArr[18]; //��������
			objSheet.Cells(3+k,7).value=auditArr[5]; //�Ľ�����
			objSheet.Cells(3+k,8).value=auditArr[6]; //��ϵ�绰
			objSheet.Cells(3+k,9).value=auditArr[7]; //�ϱ���
			objSheet.Cells(3+k,10).value=auditArr[19]; //�ϱ���ְҵ���
			objSheet.Cells(3+k,11).value=auditArr[20]; //�ϱ���ְ��
			objSheet.Cells(3+k,12).value=auditArr[8]; //�¼������ص�
			objSheet.Cells(3+k,13).value=auditArr[9]; //�¼���������
			objSheet.Cells(3+k,14).value=auditArr[10]; //��������
			objSheet.Cells(3+k,15).value=auditArr[11]; //�¼�����
			objSheet.Cells(3+k,16).value=auditArr[12]; //�¼��ȼ�
			objSheet.Cells(3+k,17).value=auditArr[13]; //һ������
			objSheet.Cells(3+k,18).value=auditArr[14]; //��������
			objSheet.Cells(3+k,19).value=auditArr[15]; //���ܲ����������
			objSheet.Cells(3+k,20).value=auditArr[16]; //�����Ľ���ʩ 
	 
	    }
		
		xlBook.SaveAs(filePath+"�����¼��벡�˰�ȫ�����ϱ����������"+yearDate+".xls");
		xlApp=null;
		xlBook.Close(savechanges=false);
		objSheet=null;

}
