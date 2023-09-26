/// Creator:    bianshuai
/// CreateDate: 2014-09-09
/// Descript:   ��ҩ����

//����Url
var url="dhcpha.clinical.action.csp";
var titleNotes='<span style="font-weight:bold;font-size:12pt;font-family:���Ŀ���;color:red;">[˫�������]</span>';
var statusArr = [{ "val": "10", "text": "����" }, { "val": "20", "text": "����" },{ "val": "30", "text": "����" },{ "val": "40", "text": "ͬ��" }];
var appType="D";
//var medAdvID="";  //qunianpeng 2016/10/18
$(function(){
	
	$("#StartDate").datebox("setValue", formatDate(-3));  //Init��ʼ����
	$("#EndDate").datebox("setValue", formatDate(0));     //Init��������
	
	$('#textarea').bind("focus",function(){
		if(this.value=="������..."){
			$('#textarea').val("");
		}
	});
	
	$('#textarea').bind("blur",function(){
		if(this.value==""){
			$('#textarea').val("������...");
		}
	});
	
	$('div[name=list]').live("click",function(){    //E8F1FF
		$('#'+this.id).css('background','#ADFAFC').css('border','1px solid #CCC')
			.siblings().css("background","").css('border','');
		$('#medAdvDetID').html(this.id);
	})
	
	///����ƶ����뿪�¼�,������ɫ�仯 ttt Ϊ��ǰѡ�����
	$('div[name=list]').live('mouseover',function(){
		if(this.id!=$('#medAdvDetID').html()){
			$(this).css('background','E8F1FF');
		}
	}).live('mouseleave',function(){
		if(this.id!=$('#medAdvDetID').html()){
			$(this).css('background','');
		}
	})
	
	//״̬
	$('#status').combobox({
		panelHeight:"auto",  //���������߶��Զ�����
		data:statusArr
	});
	
	//�ǼǺŰ󶨻س��¼�
    $('#patno').bind('keypress',function(event){
        if(event.keyCode == "13")    
        {
	        var patno=$('#patno').val();  //sufan  2016/09/13
	        getRegNo(patno);
            queryMedAdv(); //���ò�ѯ
        }
    });
    
	InitPatList();  //��ʼ�������б�
	InitMedAdvList();  //��ʼ������ģ���б�
	
	$('#Find').bind("click",queryMedAdv);    //�����ѯ
	$('#Agr').bind("click",agrMedAdv);       //ͬ��
	$('#Quo').bind("click",createMedAdvWin); //����
	$('#App').bind("click",appMedAdvDetail); //����
	$('#Del').bind("click",delMedAdvDetail); //ɾ��
	$('#Main').bind("click",medAdvTemp); //ģ��ά��
	
	queryMedAdv(); //ҳ���������Զ�����
});

//��ʼ�������б�
function InitPatList()
{
	//����columns
	var columns=[[
		{field:'medAdvTime',title:'ʱ��',width:120},
		{field:'PatBed',title:'����',width:60},
		{field:'PatNo',title:'�ǼǺ�',width:80},
		{field:'PatName',title:'����',width:80},
		{field:'CurStatus',title:'��ǰ״̬',width:70},
		{field:'PatientID',title:'PatientID',width:80},
		{field:'AdmDr',title:'AdmDr',width:80},
		{field:'medAdvID',title:'medAdvID',width:80}
	]];
	
	//����datagrid
	$('#patList').datagrid({
		//title:'�����б�',    
		url:'',
		fit:true,
		//fitColumns:true,
		rownumbers:true,
		columns:columns,
		pageSize:30, 	    // ÿҳ��ʾ�ļ�¼����
		pageList:[30,45],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onClickRow:function(rowIndex, rowData){ 
			var EpisodeID=rowData.AdmDr;
			var PatientID=rowData.PatientID;
			medAdvID=rowData.medAdvID;
			//LoadPatInfo(EpisodeID);  ///���ز��������Ҫ��Ϣ
			LoadMedAdvList(medAdvID);  ///������ϸ
		}
	});
	
	initScroll("#patList");//��ʼ����ʾ���������

}

/// ��ѯ
function queryMedAdv()
{
	var StDate=$('#StartDate').datebox('getValue'); //��ʼ����
	var EndDate=$('#EndDate').datebox('getValue');  //��ֹ����
	var patno=$('#patno').val();; 					//�ǼǺ�
	var status=$('#status').combobox('getValue');   //״̬
	if(typeof status=="undefined"){status="";}
	var params=StDate+"^"+EndDate+"^"+session['LOGON.USERID']+"^"+appType+"^"+status+"^"+session['LOGON.WARDID']+"^"+patno;
	$('#patList').datagrid({
		url:url+'?action=QueryMedAdvPatList',	
		queryParams:{
			params:params}
	});	
}
///�Զ���ȫ�ǼǺ�λ��   sufan 2016/09/13
function getRegNo(regno)
{
	var len=regno.length;
	var  reglen=10
	var zerolen=reglen-len
	for (var i=1;i<=zerolen;i++)
	{regno="0"+regno
		}
	var patno=$('#patno').val(regno);
}
function LoadMedAdvList(medAdvID)
{
	//��ȡ������Ϣ
 	 $.post(url,{action:"getPatMedAdvIn",AdvID:medAdvID},function(data,status){
	     var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
	     if(retVal!=""){
			InitMedAdivPanel(retVal);
	     }
     });
}

///���ؽ�����Ϣ
function InitMedAdivPanel(retVal)
{
	var htmlstr="";
	var medAdvDataArr=retVal.split("!");
	var AdvID=medAdvDataArr[0];             //RwoID
	var medAdvMasDateStr=medAdvDataArr[1];  //��ҩ��������Ϣ
	var medAdvDrgItmStr=medAdvDataArr[2];   //ҽ����Ϣ
	var medAdvContentStr=medAdvDataArr[3];  //������Ϣ
	
	//����Ϣ
	var medAdvMasArr=medAdvMasDateStr.split("^");
	htmlstr=htmlstr+"<div style='font-size:13pt;border-bottom: 2px solid #95B8E7;background: none repeat scroll 0% 0% #FFFFFF;padding: 10px 10px 15px 15px;position: relative;border-radius: 5px;box-shadow: 0px 3px 3px 0px #CCC inset;' id="+AdvID+" >";
	htmlstr=htmlstr+"<span style='font-weight:bold;'>��Ч�ڣ�"+medAdvMasArr[0]+"</span><span style='font-weight:bold;'>��"+medAdvMasArr[1]+"</span><span style='font-weight:bold;margin-left:30px;color:red;'>"+medAdvMasArr[2]+"</span>";
	htmlstr=htmlstr+"<br>";
	//ҽ��
	htmlstr=htmlstr+"<span style='font-weight:bold;'>ԭҽ��:</span>";
	htmlstr=htmlstr+"<br>";
	var medAdvDrgItmArr=medAdvDrgItmStr.split("||");
	for(var k=0;k<medAdvDrgItmArr.length;k++)
	{
		htmlstr=htmlstr+"<span style='margin-left:30px;'>"+medAdvDrgItmArr[k]+"</span>";
		htmlstr=htmlstr+"<br>";
	}
	//����
	var medAdvContentArr=medAdvContentStr.split("||");
	htmlstr=htmlstr+"<span style='font-weight:bold;'>��ҩ����:</span>";
	htmlstr=htmlstr+"<br>";
	for(var k=0;k<medAdvContentArr.length;k++)
	{
		var medAdvConArr=medAdvContentArr[k].split("^");
		htmlstr=htmlstr+"<div style='padding:5px;' name=list id="+medAdvConArr[4]+">";
		if(medAdvContentArr[k]!=""){
			htmlstr=htmlstr+"<span style='margin-left:30px;font-weight:bold;font-size:12pt;'>"+medAdvConArr[0]+":</span>";  //<span style='font-size:8pt;'>"+medAdvConArr[1]+" "+medAdvConArr[2]+"</span>
			htmlstr=htmlstr+"<br>";
			htmlstr=htmlstr+"<span style='margin-left:70px;font-size:12pt;'>"+medAdvConArr[3]+"</span>";
			htmlstr=htmlstr+"<br>";
		}
		htmlstr=htmlstr+"</div>";
	}
	//htmlstr=htmlstr+"<span style='margin-left:300px;font-weight:bold;'>ҩʦ��"+medAdvMasArr[3]+"</span><span style='margin-left:20px;font-weight:bold;'>"+medAdvMasArr[0]+"</span>"
	htmlstr=htmlstr+"</div>";
	
	$('#medAdvCon').html(htmlstr);
}

///������ҩ����
function appMedAdvDetail()
{
	var UserID=session['LOGON.USERID'];        ///�û�ID
	var medAdvDetailList=$('#textarea').val(); ///��ҩ����
	var row=$('#patList').datagrid('getSelected'); //qunianpeng 2016-10-18
	if(!row){
		$.messager.alert("��ʾ","����ѡ������Ϣ��");
		return ;
	}
	var medAdvID=row.medAdvID;

	if((medAdvDetailList=="������...")||(medAdvDetailList=="")){    //sufan 2016/09/09
		$.messager.alert("��ʾ","�����������,�ٽ����ύ��");
		return;
	}
	//var curStatus="40";  //����״̬   zhaowuqiang   2016/09/26
	medAdvMasList=UserID+"^"+medAdvDetailList.replace(/(^\s*)|(\s*$)/g,""); //ȥ����ʾ�ַ�

	var data=jQuery.param({"action":"SaveMedAdvDetail","AdvID":medAdvID,"dataList":medAdvMasList});
	$.ajax({
        type:"POST",
        url:url,
        data:data,
        dataType:"json",
        success: function (val) {
	    	LoadMedAdvList(medAdvID);  ///������ϸ
	    	$('#textarea').val("");    ///���textarea����
	    }
    });
}

///���ز�����ҩ�����б�
function LoadPatAdviceList()
{
	if (AdmDr==""){return;}
	$.post(url,{action:"getPatAdviceList",AdmDr:AdmDr},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal!=""){
			var medAdvPatAdvArr=retVal.split("#");
			for(var m=0;m<medAdvPatAdvArr.length;m++){
				InitAdivisesPanel(medAdvPatAdvArr[m]); //��������
			}
		}
	});
}

/// ɾ����ҩ����
function delMedAdvDetail()
{
	var AdvID=$('#AdvID').html();  //��ȡ��ǰѡ����AdvID
	if (AdvID==""){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼��");
		return;
	}
	$.post(url,{action:"delPatMedAdvDetail",AdvID:AdvID},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$('#'+AdvID).remove();
			$.messager.alert("��ʾ","ɾ���ɹ���");
		}else if(retVal=="-1"){
			$.messager.alert("��ʾ","���鲻���ڣ�");
		}else if(retVal=="-2"){
			$.messager.alert("��ʾ","ҽ���ѻظ�,����ɾ����");
		}
	});
}

function InitMedAdvList()
{
		//����columns
	var columns=[[
		{field:"ID",title:'ID',width:90,hidden:true},
		{field:'Code',title:'����',width:100},
		{field:'Desc',title:'����',width:600},
	]];
	
	//����datagrid
	$('#medAdvdg').datagrid({
		//title:'',    
		url:'',
		fit:true,
		rownumbers:true,
		columns:columns,
		pageSize:40,        // ÿҳ��ʾ�ļ�¼����
		pageList:[40,80],   // ��������ÿҳ��¼�������б�
	    singleSelect:true,
		loadMsg: '���ڼ�����Ϣ...',
		pagination:true,
		onDblClickRow:function(rowIndex, rowData){
			var tmpDesc=rowData.Desc;
			if(($('#textarea').val()=="������...")||($('#textarea').val()=="")){
				$('#textarea').val("").val(tmpDesc);
			}else{
				$('#textarea').val($('#textarea').val()+","+tmpDesc);
			}
			$('#medAdvWin').window('close');
		}
	});
	
	//initScroll();//��ʼ����ʾ���������
}

// �������ô���
function createMedAdvWin()
{	

	$('#medAdvWin').window({
		title:'�����б�'+titleNotes,    
		collapsible:true,
		border:true,
		closed:"true",
		width:800,
		height:400
	});

	$('#medAdvWin').window('open');
	
	///�Զ����ؽ����ֵ�
	$('#medAdvdg').datagrid({
		url:url+'?action=QueryMedAdvTemp',	
		queryParams:{
			params:session['LOGON.CTLOCID']+"^"+session['LOGON.USERID']
		}
	});
}

/// ɾ����ҩ������ϸ
function delMedAdvDetail()
{
	var medAdvDetID=$('#medAdvDetID').html();  //��ȡ��ǰѡ����AdvID
	if (medAdvDetID==""){
		$.messager.alert("��ʾ","��ѡ��Ҫɾ���ļ�¼��");
		return;
	}
	$.post(url,{action:"delPatMedAdvDetail",medAdvDetID:medAdvDetID},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$('#'+medAdvDetID).remove();
			$.messager.alert("��ʾ","ɾ���ɹ���");
		}else if(retVal=="-1"){
			$.messager.alert("��ʾ","���鲻���ڣ�");
		}else if(retVal=="-2"){
			$.messager.alert("��ʾ","ҽ���ѻظ�,����ɾ����");
		}
	});
}

/// ͬ��
function agrMedAdv()
{
	var row=$('#patList').datagrid('getSelected'); //qunianpeng 2016-10-18
	if(!row){
		$.messager.alert("��ʾ","��ѡ����Ҫ���ܵļ�¼��");
		return ;
	}
	var medAdvID=row.medAdvID;
	/*if (medAdvID==""){
		$.messager.alert("��ʾ","��ѡ����Ҫ���ܵļ�¼��");
		return;
	}*/
	var curStatus="30";  //ҽ��ͬ��Ϊ30
	$.post(url,{action:"agrPatMedAdv",medAdvID:medAdvID,curStatus:curStatus},function(data,status){
		var retVal=data.replace(/(^\s*)|(\s*$)/g,"");
		if(retVal=="0"){
			$.messager.alert("��ʾ","�����ɹ���");
			queryMedAdv();      //sufan 2016/09/12
			LoadMedAdvList(medAdvID);
		}else{
			$.messager.alert("��ʾ","����ʧ�ܣ�");
		}
	});
}

/// ��ҩ����ģ��ά��
function medAdvTemp()
{
	$('#medAdvTempWin').window({
		title:'��ҩ����ģ��ά��',    
		collapsible:true,
		border:true,
		closed:"true",
		width:1000,
		height:500
	});

	var iframe='<iframe scrolling="yes" width=100% height=100%  frameborder="0" src="dhcpha.clinical.medadvtemp.csp"></iframe>';
	$('#medAdvTempWin').html(iframe);
	$('#medAdvTempWin').window('open');
}

