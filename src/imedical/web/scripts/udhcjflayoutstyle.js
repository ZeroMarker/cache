// udhcjflayoutstyle.js

/**
 * Creator: tangzf
 * CreatDate: 2019-4-22
 * Description: 将Encrypt数据读取后 加载到Combobox 仅适用于 组件  并且组件中已添加相应custom元素
 * input:	ListName :组件名
 * 			txtdesc :描述
 * 			valdesc :值 
 * 			ListIdx :加载后位置 暂时不用
 * 			SelFlag :是否为默认值 (“1” 默认)
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
 * Description: add DataToDatagrid 仅适用于 组件  并且组件中已添加相应custom元素
 * input:	compoName :组件名
 * 			title :弹窗标题
 * 			icon :弹窗图标
 * 			width :弹窗宽度
 * 			height :弹窗高度
 * 			inputPara :query入参
 * 			childDgrid :第几次grid弹窗(如 弹窗后  继续弹窗)
 *			functionName :双击调用方法 Type=1 
 *			Type :弹窗类型
 */
function DHCWeb_initDatagrid(compoName,title,icon,width,height,inputPara,childDgrid,functionName,Type){
	if(!childDgrid){
		childDgrid="";
	}
	if(!Type){
		Type="1";
	}
	if(Type=="1"){ // 第一种弹窗 Datagrid
		try{
			var comObj=document.getElementById('compoDialog'+childDgrid) // div 
			if(comObj){
				comObj.setAttribute('id',compoName); //将custom默认值 改为组件Name
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
				alert("无效的组建名："+compoName);
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
				comObj.setAttribute('id','compoDialog'+childDgrid);  //还原dialog
			}
			var tcomObj=document.getElementById("t"+compoName);
			if(tcomObj){
				tcomObj.setAttribute('id','tcompoDialog'+childDgrid);
			}
		}
	}else{	
		// 第二种弹窗 window页面
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
 * Description: 更改alert弹窗为 HISUI 类型
 * input:	msg : 提示内容
 * 			type : 提示类型 决定显示的提示样式，可选属性,'success','info','alert','error'
 * 			timeout : 显示时间长度(毫秒) 0表示一直显示不消失
 * 			showSpeed : 显示速度 可选属性,'fast','slow','normal',数字(毫秒数)
 * 			showType : 显示方式 可选属性,'slide','fade','show'
 * 			style : 显示位置 right,top,left,bottom
 * 			title : 弹窗标题
 */
function DHCWeb_HISUIalert(alertmsg,fnName,alerttitle,alerttype,timeout)	{
	if(!alerttitle) alerttitle="提示";
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
 * Description: 返回指定datagrid指定行指定单元格的数据
 * input:	datagridName : datagrid 的Id 一般为 t+组件名
 * 			rowIndex : 行
 * 			itmName : 单元格Name
 * return: 单元格值
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
	var datagridObj = $HUI.datagrid(datagridName).getRows()[rowIndex] // HISUI从0开始
	rtn = eval("datagridObj."+itmName);
	return rtn;
}

/**
 * Creator: tangzf
 * CreatDate: 2019-5-20
 * Description:  修改组件布局样式 侧菜单
 * input:	Flag 是否使用 onLoadSuccess 方法 空 或者 false 使用该方法
 * return: 
 */
function DHCWeb_ComponentLayout() {
	$('#PageContent').parent().css("padding","0px"); // 贴边放
	$('#PageContent>table').css("border-spacing","0px 9px"); //行距
	$('#PageContent>table').find('label').css("margin-right","9px"); // 标签输入框间隙
	$('#PageContent').find('.panel-body').css("border-radius","0px"); //去掉圆角
	$('#PageContent').find('.panel-body').css("border-left","0px");	//去掉左边框
	$('#PageContent>table').find('label[for]').css("margin-right","0px") //checkbox 间隙
	$('.first-col').css('padding-left','6px');
	$('.first-col').parent().parent().parent().css('margin-top','2px');
	$('#PageContent').find('.panel-body-noheader').css('margin-top','1px');
}