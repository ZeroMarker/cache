// udhcjflayoutstyle.js

/**
 * Creator: tangzf
 * CreatDate: 2019-4-22
 * Description: ��Encrypt���ݶ�ȡ�� ���ص�Combobox �������� ���  ����������������ӦcustomԪ��
 * input:	ListName :�����
 * 			txtdesc :����
 * 			valdesc :ֵ 
 * 			ListIdx :���غ�λ�� ��ʱ����
 * 			SelFlag :�Ƿ�ΪĬ��ֵ (��1�� Ĭ��)
 */
function DHCWeb_AddToCombobox(ListName, txtdesc, valdesc, ListIdx, SelFlag)	{
	var ListObj = document.getElementById(ListName);
	if (!ListObj) {
		return;
	}
	var aryitmdes = websys_trim(txtdesc);
	var aryitminfo = websys_trim(valdesc);
	if (aryitmdes.length > 0) {
		var data = $("#" + ListName).combobox('getData');
		var obj = {"text": aryitmdes, "id": aryitminfo};
		if (SelFlag == "1") {
			obj = $.extend(obj, {"selected": true});
		}
		data.push(obj);
 		$("#"+ListName).combobox("loadData", data);
	}
}

/**
 * Creator: tangzf
 * CreatDate: 2019-4-22
 * Description: add DataToDatagrid �������� ���  ����������������ӦcustomԪ��
 * input:	compoName :�����
 * 			title :��������
 * 			icon :����ͼ��
 * 			width :�������
 * 			height :�����߶�
 * 			inputPara :query���
 * 			childDgrid :�ڼ���grid����(�� ������  ��������)
 *			functionName :˫�����÷��� Type=1 
 *			Type :��������
 */
function DHCWeb_initDatagrid(compoName,title,icon,width,height,inputPara,childDgrid,functionName,Type){
	if(!childDgrid){
		childDgrid="";
	}
	if(!Type){
		Type="1";
	}
	if(Type=="1"){ // ��һ�ֵ��� Datagrid
		try{
			var comObj=document.getElementById('compoDialog'+childDgrid) // div 
			if(comObj){
				comObj.setAttribute('id',compoName); //��customĬ��ֵ ��Ϊ���Name
			}
			var tcomObj=document.getElementById('tcompoDialog'+childDgrid)  // table
			if(tcomObj){
				tcomObj.setAttribute('id','t'+compoName);
			}
			var comName="#"+compoName;
			var tcomName="#t"+compoName;
			$(comName).show();
			$(comName).dialog({
				width: width,
				height: height,
				iconCls: icon,
				title: title ,
				draggable: false,
				modal: true
			});
			var cmpInfo= tkMakeServerCall("DHCBILL.Common.DHCBILLLayOutStyle", "GetComponentInfoByName", compoName).split("^");
			if(cmpInfo[0]<0){
				alert("��Ч���齨����"+compoName);
				return;
			}
			var cmpRowId=cmpInfo[0]
			inputPara="?ClassName="+cmpInfo[1]+"&QueryName="+cmpInfo[2]+"&"+inputPara
			var cminfo = $.cm({dataType:"text",ClassName:"websys.hisui.ComponentUserImp",MethodName:"ColumnToJson",cmpId:cmpRowId},false);
			eval("cminfo="+cminfo);
			var dgobj=$HUI.datagrid(tcomName, {
				fit: true,
				bodyCls: 'panel-body-gray',
				checkOnSelect: false,
				selectOnCheck: false,
				singleSelect: true,
				autoRowHeight: false,
				rownumbers: true,
				onDblClickHeader:function(e,field){e.preventDefault();var flag = $.cm({ClassName:"web.SSGroup",MethodName:"GetAllowWebColumnManager",Id:session['LOGON.GROUPID']},false);if(flag==1) websys_lu('../csp/websys.component.customiselayout.csp?ID='+cmpRowId,false,'hisui=true');return false;},	
				onDblClickRow:function(rowIndex, rowData){
					if(functionName){window[functionName](rowData);}
				},
				pagination:true,
				pageSize:cminfo.pageSize==15?15:cminfo.pageSize,
				showPageList:false,
				url:$URL+inputPara,
				columns:[cminfo.cm],
			});	
		}catch(e){
			alert(e.message);
		}finally{	
			var comObj=document.getElementById(compoName);
			if(comObj){
				comObj.setAttribute('id','compoDialog'+childDgrid);  //��ԭdialog
			}
			var tcomObj=document.getElementById("t"+compoName);
			if(tcomObj){
				tcomObj.setAttribute('id','tcompoDialog'+childDgrid);
			}
		}
	}else{	
		// �ڶ��ֵ��� windowҳ��
		var ModalObj=websys_showModal({
			width: width,
			height: height,
			iconCls: icon,
			title: title ,
			url:inputPara,
		});
	}
}

/**
 * Creator: tangzf
 * CreatDate: 2019-4-30
 * Description: ����alert����Ϊ HISUI ����
 * input:	msg : ��ʾ����
 * 			type : ��ʾ���� ������ʾ����ʾ��ʽ����ѡ����,'success','info','alert','error'
 * 			timeout : ��ʾʱ�䳤��(����) 0��ʾһֱ��ʾ����ʧ
 * 			showSpeed : ��ʾ�ٶ� ��ѡ����,'fast','slow','normal',����(������)
 * 			showType : ��ʾ��ʽ ��ѡ����,'slide','fade','show'
 * 			style : ��ʾλ�� right,top,left,bottom
 * 			title : ��������
 */
function DHCWeb_HISUIalert(alertmsg,fnName,alerttitle,alerttype,timeout)	{
	if(!alerttitle) alerttitle="��ʾ";
	if(!alerttype) alerttype="info";
	if(!timeout) timeout = 400;
	setTimeout(function(){
		$.messager.alert(alerttitle, alertmsg, alerttype,function(){
			if(typeof fnName == 'function')	{
				fnName();
			}
		});
	},timeout);
}

/**
 * Creator: tangzf
 * CreatDate: 2019-5-10
 * Description: ����ָ��datagridָ����ָ����Ԫ�������
 * input:	datagridName : datagrid ��Id һ��Ϊ t+�����
 * 			rowIndex : ��
 * 			itmName : ��Ԫ��Name
 * return: ��Ԫ��ֵ
 */
function DHCWeb_GetDatagridInfo(datagridName, rowIndex, itmName)	{
	var rtn = "";
	if(!datagridName){
		return "";
	}
	var RowNums=$HUI.datagrid(datagridName).getRows().length;	
	if(RowNums=='0'||RowNums<rowIndex){
		return "";
	}
	var datagridObj = $HUI.datagrid(datagridName).getRows()[rowIndex] // HISUI��0��ʼ
	rtn = eval("datagridObj."+itmName);
	return rtn;
}

/**
 * Creator: tangzf
 * CreatDate: 2019-5-20
 * Description:  �޸����������ʽ ��˵�
 * input:	Flag �Ƿ�ʹ�� onLoadSuccess ���� �� ���� false ʹ�ø÷���
 * return: 
 */
function DHCWeb_ComponentLayout() {
	$('#PageContent').parent().css("padding","0px"); // ���߷�
	$('#PageContent>table').css("border-spacing","0px 9px"); //�о�
	$('#PageContent>table').find('label').css("margin-right","9px"); // ��ǩ������϶
	$('#PageContent').find('.panel-body').css("border-radius","0px"); //ȥ��Բ��
	$('#PageContent').find('.panel-body').css("border-left","0px");	//ȥ����߿�
	$('#PageContent>table').find('label[for]').css("margin-right","0px") //checkbox ��϶
	$('.first-col').css('padding-left','6px');
	$('.first-col').parent().parent().parent().css('margin-top','2px');
	$('#PageContent').find('.panel-body-noheader').css('margin-top','1px');
}