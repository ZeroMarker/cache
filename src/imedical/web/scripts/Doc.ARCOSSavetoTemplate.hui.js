var PageLogicObj={
	m_AddToOrdTemplARCOSDatas:"",
	pattern:new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]") 
}
$(function(){
	ExtendHISUICombo();
	//事件初始化
	InitEvent();
	//页面元素初始化
	PageHandle();
	ResizeWindow();
})
function InitEvent(){
	$("#BAddTabName").click(BAddTabNameClick);
	$("#BAddTemplGroup").click(BAddTemplGroupClick);
	//新增模板组 保存
	$("#BSaveGroup").click(BSaveGroupClickHandle);
	//新增模板子表 保存
	$("#BSaveTabName").click(BSaveTabNameClickHandle);
	$("#BSave").click(BSaveClickHandle);
}
function PageHandle(){
	var obj = window.dialogArguments;
	if (obj) {
		PageLogicObj.m_AddToOrdTemplARCOSDatas=obj.name;
	}else{
		PageLogicObj.m_AddToOrdTemplARCOSDatas=websys_showModal("options").paraObj.name;
	}
	InitTempl();
}
function BAddTabNameClick(){
	$("#AddTabName-tr").show();
	$("#TemplTabNameDesc").val('').focus();
	ResizeWindow();
}
function BAddTemplGroupClick(){
	$("#AddGroup-tr").show();
	$("#TemplGroupDesc").val('').focus();
	ResizeWindow();
}
function InitTempl(){
	InitTemplCategory();
	InitTemplTabName();
	InitTeplGroup();
}
function InitTemplCategory(){
	var dataArr=new Array();
	dataArr.push({"id":"User.SSUser","text":$g("个人"),selected:true});
	if(ServerObj.MenuAuthOrderOrgFav==1){
		dataArr.push({"id":"User.CTLoc","text":$g("科室")});
	}
	if(ServerObj.HospMenuAuthOrderOrgFav==1){
		dataArr.push({"id":"User.CTHospital","text":$g("全院")});
	}
	$("#TemplCategory").combobox({
		valueField: 'id',
		textField: 'text', 
		editable:false,
		data: dataArr,
		panelHeight:'auto',
		onSelect:function(){
			$('#TemplTabName').combobox('reload');
		},
		onLoadSuccess:function(){
			$('#TemplTabName').combobox('reload');
		}
	 });
}
//模板大类
function InitTemplTabName(){
	$('#TemplTabName').combobox({
		url:'websys.Broker.cls',
		valueField: 'id',
		textField: 'text', 
		editable:false,
		panelHeight:100,
		onSelect:function(rec){
			if(rec) $("#TemplGroup").combobox('loadData',rec.children);
			else $("#TemplGroup").combobox('loadData',[]);
		},
		onBeforeLoad:function(param){
			var ObjectType=$("#TemplCategory").combobox('getValue');
			$.extend(param,{
				ClassName:"DHCDoc.Order.Fav",
				MethodName:"GetFavData", 
				Type:ObjectType,
				CONTEXT:GetXCONTEXT(), 
				LocID:session['LOGON.CTLOCID'],
				UserID:session['LOGON.USERID'],
				OnlyCatNode:1
			});
			$(this).combobox('select','');
			return true;
		},
		onLoadSuccess:function(data){
			if(data.length)
				$(this).combobox('select',data[0].id);
		}
	});
}
//模板子分类类
function InitTeplGroup(){
	$("#TemplGroup").combobox({
		valueField: 'id',
		textField: 'text', 
		data: [],
		panelHeight:55,
		onLoadSuccess:function(data){
			if(data.length){
				$(this).combobox('select',data[0].id);
			}else{
				$(this).combobox('select','');
			}
		}
	});
}
function BSaveGroupClickHandle(){
	var AddTabName=$.trim($("#TemplTabNameDesc").val());
	if (AddTabName==""){
		$.messager.alert("提示","模板大类描述不能为空!","info",function(){
			$("#TemplTabNameDesc").focus();
		})
		return false;
	}
	if (PageLogicObj.pattern.test(AddTabName)){
		$.messager.alert("提示","模板大类描述【"+AddTabName+"】含有非法字符!","info",function(){
			$("#TemplTabNameDesc").focus();
		});
		return false;
	}
	var data=$("#TemplTabName").combobox('getData');
	for (var i=0;i<data.length;i++){
		if (data[i]["text"]==AddTabName){
			$.messager.alert("提示",AddTabName+$g(" 已存在!"),"info",function(){
				$("#TemplTabNameDesc").focus();
			});
			return false;
		}
	}
	var ObjectType=$("#TemplCategory").combobox('getValue');
	var ret=$.cm({
		ClassName:'DHCDoc.Order.Fav',
		MethodName:'SaveCat',
		Type:ObjectType,
		CONTEXT:GetXCONTEXT(), 
		Name:AddTabName,
		LocID:session['LOGON.CTLOCID'],
		UserID:session['LOGON.USERID'],
		ID:'',
		dataType:'text'
	},false);
	if(ret.split('^')[0]=='0'){
		$('#TemplTabName').combobox('reload');
		$.messager.popover({msg:'保存成功',type:'success'});
		$("#AddTabName-tr").hide();
		$("#TemplTabNameDesc").val('');
		setTimeout(function(){$('#TemplTabName').combobox('setValueByText',AddTabName);},200);
		ResizeWindow();
	}else{
		$.messager.alert('提示',ret,'warning',function(){$("#TemplTabNameDesc").select()});
	}
}
function BSaveTabNameClickHandle(){
	var AddGroupDesc=$.trim($("#TemplGroupDesc").val());
	if (AddGroupDesc==""){
		$.messager.alert("提示","模板子分类类描述不能为空!","info",function(){
			$("#TemplGroupDesc").focus();
		})
		return false;
	}
	if (PageLogicObj.pattern.test(AddGroupDesc)){
		$.messager.alert("提示","模板子分类类描述【"+AddGroupDesc+"】含有非法字符!","info",function(){
			$("#TemplGroupDesc").focus();
		});
		return false;
	}
	var CatID=$("#TemplTabName").combobox('getValue');
	if (CatID==""){
		$.messager.alert("提示","请先选择要加入的模板大类");
		return false;
	}
	var ret=$.cm({
		ClassName:'DHCDoc.Order.Fav',
		MethodName:'SaveSubCat',
		ID:'',
		CatID:CatID,
		Name:AddGroupDesc, 
		UserID:session['LOGON.USERID'], 
		dataType:'text'
	},false);
	if(ret.split('^')[0]=='0'){
		var oldValue=$('#TemplTabName').combobox('getValue');
		$('#TemplTabName').combobox('reload');
		setTimeout(function(){$('#TemplTabName').combobox('select',oldValue);},200);
		setTimeout(function(){$('#TemplGroup').combobox('setValueByText',AddGroupDesc);},300);
		$("#AddGroup-tr").hide();
		$("#TemplGroupDesc").val('');
		$.messager.popover({msg:'保存成功',type:'success'});
		ResizeWindow();
	}else{
		$.messager.alert('提示',ret,'warning',function(){$("#TemplGroupDesc").find('input').select()});
	}
}
function BSaveClickHandle(){
	var SubCatID=$('#TemplGroup').combobox('getValue');
	if(SubCatID==''){
		return false;
	}
	var itemArr=new Array();
	itemArr.push({'itemid':PageLogicObj.m_AddToOrdTemplARCOSDatas,note:'',partInfo:''});
	if(itemArr.length){
		var ret=$.cm({ 
			ClassName:"DHCDoc.Order.Fav",
			MethodName:"InsertMultItem", 
			FavItemStr:JSON.stringify(itemArr),
			SubCatID:SubCatID,
			UserID:session['LOGON.USERID'],
			dataType:'text'
		},false);
		if(ret=='0'){
			$.messager.alert("提示","保存到模板成功!","info",function(){
				websys_showModal("hide");
				if (websys_showModal('options').CallBackFunc) {
					websys_showModal('options').CallBackFunc();
				}			
				websys_showModal("close");
				return true;
			})
			return true
		}else{
			$.messager.alert('提示','保存模板失败:'+ret);
			return false;
		}
	}
	return true
}
function mPiece(str,deli,index){
	return str.split(deli)[index];
}
function getCombValue(id,valueField){
	var Find=0;
	var selId=$('#'+id).combobox('getValue');
	var Data=$("#"+id).combobox('getData');
	for(var i=0;i<Data.length;i++){
		 var CombValue=Data[i][valueField];
		  if(selId==CombValue){
			  selId=CombValue;
			  Find=1;
			  break;
	      }
	 }
	 if (Find=="1") return selId
	 return "";
}
function GetXCONTEXT()
{
	var XCONTEXT = "WNewOrderEntry";
	if (ServerObj.Type == "草药") XCONTEXT="W50007";
	return XCONTEXT;
}
function ExtendHISUICombo()
{
	$.extend($.fn.combobox.methods, {    
	    setValueByText: function(jq, text){    
	        return jq.each(function(){  
	        	var opts=$(this).combobox('options');
	        	var data=$(this).combobox('getData');
	        	for(var i=0;i<data.length;i++){
		        	if(data[i][opts.textField]==text){  
	            		$(this).combobox('select', data[i][opts.valueField]);
	            		break;
		        	}
	        	} 
	        });    
	    }    
	});
}
function ResizeWindow(){
	var height=15;
	$('.search-table').find('tr:visible').each(function(){
		height+=$(this).outerHeight()+10;
	});
	parent.websys_showModal('resize',{height:height+55,width:460});
	parent.websys_showModal('center');
}