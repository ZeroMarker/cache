//������ѯ���� �ı�ʱ �Ƿ�������ѯ
var ActionTypeOnChange = function(){
	//$('#FindBtn').click();        //�ı���Ϣ���Ͳ�ѯ��������������
};
var FromUserOnChange = function(){
	//$('#FindBtn').click();         //�����û�
};
var ToUserOnChange = function(){
	//$('#FindBtn').click();         //�����û�
};
var DExecFlagOnChange = function(){
	//$('#DFindBtn').click();       //Detailsҳ�� ����״̬
};
var DToUserOnChange = function(){
	//$('#DFindBtn').click();       //Detailsҳ�� �����û�
};
//----------������ѯ���� �ı�ʱ �Ƿ�������ѯ

//���ڸ�ʽУ��
function CheckDate(str){
	if(str==""){return true;}
	if(dateformat==4){
		var RegStr=/^((((0[1-9]|[12][0-9]|3[01])\/(0[13578]|1[02]))|((0[1-9]|[12][0-9]|30)\/(0[469]|11))|((0[1-9]|[1][0-9]|2[0-8])\/02))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
	}else if(dateformat==1){
		var RegStr=/^((((0[13578]|1[02])\/(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)\/(0[1-9]|[12][0-9]|30))|(02\/(0[1-9]|[1][0-9]|2[0-8])))\/([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3}))|(02\/29\/(([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00)))$/;
	}else{
		var RegStr=/^(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)$/;
	}
	if (str.match(RegStr)==null){
		return false;
	}else{
		return true;
	}
}
//ȥ��html��ǩ
var replaceHtml=function(str){
	 return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
}
var contentFlag="N";
$(function(){
	$('#DateEnd').datebox('setValue',now);
	$('#DateStart').datebox('setValue',now);
	var findTableHeight=parseInt($("#PageContent>table").css('height'));
	var dheight=500;
	var dsize=15;
	var trheight=27;   //datagridһ�еĸ߶�
	if (document.documentElement && document.documentElement.clientHeight && document.documentElement.clientWidth){
		var winHeight = document.documentElement.clientHeight;
		var winWidth = document.documentElement.clientWidth;
		dheight=winHeight-findTableHeight-35;
		dsize=parseInt((dheight-35-20)/trheight)-1;
	}
	$('#tDHCMessageContent').datagrid({
		queryParams: { DateStart : "", DateEnd : "", ToUser : "", FromUser : "", PatName : "", ActionType : ""},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageContentMgr&QueryName=FindByDateIndex',
		idField:'ContentId' ,
		height:dheight,
		singleSelect:false,
		pageSize:dsize,
		rownumbers: true,
		pagination: true,
		pageList: [dsize,30,50],  
		striped: true ,			
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'ContentId',title:'��Ϣ����ID',hidden:true} ,
			{field:'CActionTypeDesc',title:'��Ϣ����'} ,
			{field:'CText',title:'��Ϣ����',width:500,formatter: function(value,row,index){
				value=replaceHtml(value);
				return "<span title='"+value+"'>"+value+"</span>";
			}} ,
			{field:'CSendDate',title:'����ʱ��',formatter: function(value,row,index){
				return value+" "+row['CSendTime'];
			}} ,
			{field:'CFromUserName',title:'�����û�'} ,
			{field:'CExecFlag',title:'����״̬',formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>�Ѵ���</span>";
				}else if (value=="O"){
					return "<span>���账��</span>";
				}else{
					return "<span>δ����</span>";
				}
				
			}},
			{field:'CExecUser',title:'������'},
			{field:'CExecDateTime',title:'����ʱ��'},
			{field:'CStatus',title:'��ע',formatter: function(value,row,index){
				if (value=="R") {
					return "������Ϣ�����账��";
				}else if (value=="E"){
					return "ҵ����������";
				}else if (value=="D"){
					return "���˳�Ժ�Զ�����";
				}else if (value=="EP"){
					return "��Ϣ����,�Զ�����";
				}else if (value=="C"){
					return "��Ϣ�ѳ���";
				}else if (value=="F"){
					return "ǿ�ƴ���";
				}else{
					return "";
				}
				
			}},
			{field:'CViewLoc',title:'�鿴����',formatter: function(value,row,index){
				return "<span title='���û���¼���¿��ҲŻ���ʾ����Ϣ\n"+value+"'>"+value+"</span>";	
			}}			
		]],
		onDblClickRow: function (rowIndex, rowData) {  //˫���д�Details��ͬʱ����Content�Ĳ�ѯ���� ����״̬�ͽ����û� ��Ϊ��һ�δ�Details�ĵĲ�ѯ����
			var contentInfo=rowData.CActionTypeDesc+"&nbsp;&nbsp;&nbsp;&nbsp;"+rowData.CText.split("<br>")[0].substring(0,15)+""+(rowData.CText.length>15 ? "..." :"") +"&nbsp;&nbsp;&nbsp;&nbsp;  "+rowData.CFromUserName+"��"+rowData.CSendDate+"����"
			$('#ContentInfo').html(contentInfo);
			$('#mydialog').dialog('open');
			$('#DetailsContentId').val(rowData.ContentId);
			if(rowData.CExecFlag=="Y"){           //ContentΪ����DetailsĬ�ϲ��Ѵ���   ContentΪδ��������账�� DetailsĬ�ϲ�δ���� 
				$('#DExecFlag').combobox('setValue',"Y");
				contentFlag=="Y";
			}else{
				$('#DExecFlag').combobox('setValue',"N");
				contentFlag=="N";
			}
			$('#DToUser').combogrid('setValue',$('#ToUser').combogrid('getValue'));
			$('#DToUser').combogrid('setText',$('#ToUser').combogrid('getText'));
			$('#DFindBtn').click();
		}
		
	});
	
	
	$('#FromUser').combogrid({
		width:200,
		disabled:false,		
		delay: 500,
		panelWidth:200,
		mode: 'remote',
		queryParams:{ClassName:'web.SSUser',QueryName: 'LookUpWithInactive',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		onSelect:FromUserOnChange,
		columns: [[{field:'Name',title:'����',width:180},{field:'Code',title:'Code',align:'right',hidden:true,width:0},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
	});
	$('#ToUser').combogrid({
		width:200,
		disabled:false,		
		delay: 500,
		panelWidth:200,
		mode: 'remote',
		queryParams:{ClassName:'web.SSUser',QueryName: 'LookUpWithInactive',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		onSelect:ToUserOnChange,
		columns: [[{field:'Name',title:'����',width:180},{field:'Code',title:'Code',align:'right',hidden:true,width:0},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
	});

	$('#FindBtn').click(function(){
		$('#tDHCMessageContent').datagrid('unselectAll');    //��ѯʱȡ��ѡ�����
		var datestart=$('#DateStart').datebox('getValue');
		if(!CheckDate(datestart)){
			$.messager.alert('ʧ��','��ʼ���ڸ�ʽ����ȷ!');
			return false;
		}
		var dateend=$('#DateEnd').datebox('getValue');
		if(!CheckDate(dateend)){
			$.messager.alert('ʧ��','�������ڸ�ʽ����ȷ!');
			return false;
		}
		
		if (dateend==""){                                  //��������Ϊ�գ�ȡ����   
			dateend=now;
			$('#DateEnd').datebox('setValue',dateend);
		}
		if(datestart==""||$.fn.datebox.defaults.parser(datestart)>$.fn.datebox.defaults.parser(dateend)){             //��ʼ����Ϊ�գ����߿�ʼ���ڴ��ڽ�������  ȡ����������һ��
			datestart=dateend;
			$('#DateStart').datebox('setValue',datestart);
		}
		var touser=$('#ToUser').combogrid('getValue');
		var fromuser=$('#FromUser').combogrid('getValue');
		var actiontype=$('#ActionType').combobox('getValue');
		
		var patname=$('#PatName').val();
		//alert(datestart+"^"+dateend+"^"+touser+"^"+fromuser+"^"+actiontype+"^"+execflag);
		$('#tDHCMessageContent').datagrid('load',{ DateStart : datestart, DateEnd : dateend, ToUser : touser, FromUser : fromuser, PatName : patname, ActionType : actiontype});
		
	});
	//Contentҳ�洦��ѡ�е���Ϣ����������Ҫ��Content����ͬʱ���������Details�����
	$('#ExecBtn').click(function(){
		var rows=$('#tDHCMessageContent').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.alert('ʧ��','����ѡ��һ������!');
			return false;
		}
		var ContentIds=[];
		for (var i=0;i<rows.length;i++) {
			ContentIds.push(rows[i].ContentId);
		}
		var ContentIdsStr=ContentIds.join("^");
		//alert(ContentIdsStr);
		
		//$('#tDHCMessageContent').datagrid('unselectAll');
		//return false;     //��return ��ʱ������̨
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageInterface",
			MethodName:"ExecAllByContentIds",
			ContentIds:ContentIdsStr
			},
			function(data,textStatus){
				if(data>0){
					$('#FindBtn').click();
					$.messager.alert('�ɹ�','����ɹ�!');
				}else{
					$.messager.alert('�ɹ�','����ʧ��!');
				}
			}
		);
		
	});
	
	$('#ClearBtn').click(function(){
		$('#ToUser').combogrid('clear');
		$('#FromUser').combogrid('clear');
		$('#DateEnd').datebox('setValue',now);
		$('#DateStart').datebox('setValue',now);
		$('#ActionType').combobox('setValue','');
		$('#PatName').val("");
		$('#FindBtn').click();
	})
	
	
	//Detailsҳ�� datagrid
	$('#tDHCMessageDetails').datagrid({
		queryParams: { ContentId : "", ToUser : "", ExecFlag : "N"},
		url:'jquery.easyui.querydatatrans.csp?ClassName=websys.DHCMessageDetailsMgr&QueryName=FindByContent',
		idField:'DetailsId' ,
		height:330,
		fitColumns:true,
		singleSelect:false,
		pageSize:10,
		rownumbers: true,
		pagination: true,
		pageList: [10],  
		striped: true ,		
		columns:[[
			{ field: 'ck', checkbox: true },
			{field:'DetailsId',title:'��ϢDetailsId',hidden:true,width:0} ,
			{field:'UserName',title:'�����û�',width:120} ,
			{field:'DReadFlag',title:'�Ķ�״̬',width:80,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>�Ѷ�</span>";
				}else{
					return "<span>δ��</span>";
				}
			}},
			{field:'DReadDateTime',title:'�Ķ�ʱ��',width:120} ,
			{field:'DExecFlag',title:'����״̬',width:80,formatter: function(value,row,index){
				if (value=="Y") {
					return "<span>�Ѵ���</span>";
				}else{
					return "<span>δ����</span>";
				}
			}},
			{field:'DExecUser',title:'�����û�',width:120},
			{field:'DExecDateTime',title:'����ʱ��',width:120} ,
			{field:'DTargetRole',title:'��ɫ',width:120,formatter:function(val){
				return '<span title="'+val+'">'+val+'</span>'
			}} 
		]]
	});
	$('#DToUser').combogrid({      //�������ڵ��û�combobox
		width:200,
		disabled:false,		
		delay: 500,
		panelWidth:200,
		mode: 'remote',
		queryParams:{ClassName:'web.SSUser',QueryName: 'LookUpWithInactive',desc:""},
		url: 'jquery.easyui.querydatatrans.csp',
		idField: 'HIDDEN',
		textField: 'Name',
		onBeforeLoad:function(param){
			param = $.extend(param,{desc:param.q});
			return true;
		},
		onSelect:DToUserOnChange,
		columns: [[{field:'Name',title:'����',width:180},{field:'Code',title:'Code',align:'right',hidden:true,width:0},{field:'HIDDEN',title:'HIDDEN',align:'right',hidden:true,width:0}]]
	});
	
	$('#DFindBtn').click(function(){
		$('#tDHCMessageDetails').datagrid('unselectAll');    //��ѯʱȡ��ѡ�����
		var dtouser=$('#DToUser').combogrid('getValue');
		var dexecflag=$('#DExecFlag').combobox('getValue');
		var contentid=$('#DetailsContentId').val();
		//alert(datestart+"^"+dateend+"^"+touser+"^"+fromuser+"^"+actiontype+"^"+execflag);
		$('#tDHCMessageDetails').datagrid('load',{ ContentId : contentid, ToUser : dtouser, ExecFlag : dexecflag});
		
	});
	
	//Detailsҳ�洦��ѡ�е���Ϣ����������ֻ����ѡ�е�Details
	$('#DExecBtn').click(function(){
		var rows=$('#tDHCMessageDetails').datagrid('getSelections');
		if (rows.length<=0){
			$.messager.alert('ʧ��','����ѡ��һ������!');
			return false;
		}
		//if(rows[0].DExecFlag=="Y"){            //���۴���״̬��ζ�����
		//	$.messager.alert('ʧ��','��ѡ������Ѵ�������!');
		//	return false;
		//}
		var DetailsIds=[];
		for (var i=0;i<rows.length;i++) {
			DetailsIds.push(rows[i].DetailsId);
		}
		var DetailsIdsStr=DetailsIds.join("^");
		//alert(DetailsIdsStr);
		//$('#tDHCMessageDetails').datagrid('unselectAll');
		//return false;     //��return ��ʱ������̨
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageInterface",
			MethodName:"ExecOneByDetailsIds",
			DetailsIds:DetailsIdsStr
			},
			function(data,textStatus){
				if(data>0){
					$('#DFindBtn').click();
					$.messager.alert('�ɹ�','����ɹ�!');
				}else{
					$.messager.alert('�ɹ�','����ʧ��!');
				}
			}
		);
		
	});
	
	//Detailsҳ�洦������,ֱ�Ӹ���ContentId����Ӧ�ü���
	$('#DExecAllBtn').click(function(){
		var contentid=$('#DetailsContentId').val();
		
		//alert(contentid);
		$('#DFindBtn').click();
		$('#tDHCMessageDetails').datagrid('unselectAll');
		//return false;     //��return ��ʱ������̨
		$.ajaxRunServerMethod({
			ClassName:"websys.DHCMessageInterface",
			MethodName:"ExecAllByContentIds",
			ContentIds:contentid
			},
			function(data,textStatus){
				if(data>0){
					$.messager.alert('�ɹ�','����ɹ�!');
					$('#FindBtn').click();//����ɹ���ˢ��Content��
				}else{
					$.messager.alert('�ɹ�','����ʧ��!');
				}
			}
		);
		
	});
	
	$('#DClearBtn').click(function(){
		$('#DExecFlag').combobox('setValue',contentFlag);
		$('#DToUser').combogrid('setValue',"");
		$('#DToUser').combogrid('setText',"");
		//$('#DToUser').combogrid('setValue',$('#ToUser').combogrid('getValue'));
		//$('#DToUser').combogrid('setText',$('#ToUser').combogrid('getText'));
		$('#DFindBtn').click();
	})
})