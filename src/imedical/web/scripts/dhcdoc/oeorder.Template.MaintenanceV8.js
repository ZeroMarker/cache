var PageLogicObj = {
	maxListGroupNum:5,
	websysPrefId:"",
	TableNameSelectIndex:"",
	listGroupSelectIndex:1,
	OrdCatRowId:"",
	OrdSubRowId:"",
	itemdataDelim:String.fromCharCode(4),
	groupitemDelim:String.fromCharCode(28),
	tabgroupDelim:String.fromCharCode(1),
	m_LastType:"",
	pattern:new RegExp("[`~!@#$^&*()=|{}':;',\\[\\].<>/?~！@#￥……&*（）——|{}【】‘；：”“'。，、？]") 
}
$(window).load(function() {
	ReSetWidth();
});
$(function(){
	//初始化
	Init();
	InitEvent();
	//页面元素初始化
	PageHandle();
});
function InitEvent(){
	$HUI.radio(".hisui-radio",{
        onChecked:function(e,value){
	        PreftabTypeClickHandle(e,value);
        }
    });
    $HUI.checkbox(".hisui-checkbox",{
        onCheckChange:function(e,value){
	        CMCheckClickHandle(e,value);
        }
    });
    $("select[id*='ListGroup_']").click(function(e){
	     ListGroupClickHandle(this.id);
	});
	$("select[id*='ListGroup_']").dblclick(function () {
		var ListGroupObj=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex)[0];
		for (var i=ListGroupObj.length-1;i>=0;i--){
			if (ListGroupObj.options[i].selected == true) {
				if (ListGroupObj.options[i].value==this.value) {
					selObj=ListGroupObj.options[i];
					break;
				}
			}
		}
	     OpenOrdItemNotesDialog(selObj);
	})

	$("select[id*='NameGroup_']").click(function(e){
		NameGroupClickHandle(this.id);
	})
	$("#TempTableNameList").change(function(e){
		$("#selTabName").val($("#TempTableNameList").find('option:selected').text());
		$("#OrdCategory,OrdSubCategory").combobox('select','');
		SelTabName();
	})
	$("#AddTable").click(AddTableClickHandle);
	$("#DeleteTable").click(DeleteTableClickHandle);
	$("#MoveUpTable").click(function(){
		listbox_move("MoveUpTable","TempTableNameList","up");
		UpdateClickHandle();
	});
	$("#MoveDownTable").click(function(){
		listbox_move("MoveDownTable","TempTableNameList","down");
		UpdateClickHandle();
	});
	
	$("#Update").click(UpdateClickHandle);
	$("#DeleteOrdItem").click(DeleteOrdItemHandle);
	$("#MoveUpOrdItem").click(function(){
		var id="ListGroup_"+PageLogicObj.listGroupSelectIndex;
		listbox_move("MoveUpOrdItem",id,"up")
	});
	$("#MoveDownOrdItem").click(function(){
		var id="ListGroup_"+PageLogicObj.listGroupSelectIndex;
	    listbox_move("MoveDownOrdItem",id,"down")
	});
	$("#MoveLeftOrdItem").click(function(){
		var sourceID="ListGroup_"+PageLogicObj.listGroupSelectIndex;
		var destID="ListGroup_"+(parseInt(PageLogicObj.listGroupSelectIndex)-1);
	    listboxMoveacross("MoveLeftOrdItem",sourceID,destID)
	});
	$("#MoveRightOrdItem").click(function(){
		var sourceID="ListGroup_"+PageLogicObj.listGroupSelectIndex;
		var destID="ListGroup_"+(parseInt(PageLogicObj.listGroupSelectIndex)+1);
	    listboxMoveacross("MoveRightOrdItem",sourceID,destID)
	});
	$("#CopyOrdItem").click(CopyOrdItemHandle);
	$("#PasteOrdItem").click(PasteOrdItemHandle);
	$("#CopyAllOrdItem").click(CopyAllOrdItemHandle);
	$("#PasteAllOrdItem").click(PasteAllOrdItemHandle);
	$(window).resize(function() {
		setTimeout(function() { ReSetWidth(); }, 250);
    });
    $("#BOrdItemNotesSave").click(OrdItemNotesSave);
    $("#ListGroup_").click(function(e){
		NameGroupClickHandle(this.id);
	})
	$("#ChangeOrdItemNotes").click(ChangeOrdItemNotes);
	$(document.body).bind("keydown",BodykeydownHandler)
}
function PageHandle(){
	InitOrdCategory();
	InitOrdSubCategory();
	InitOrdItemLookUp();
}
function Init(){
	$("#TempTableNameList").css('height',$(window).height()-280);
	$(".list-group").css('height',$(window).height()-262);
	SetSaveParamText();
	SetSaveParaTip();
	LoadTempData();
}
function UpdateClickHandle(){
	if ($("#Update").hasClass('l-btn-disabled')){
		return false;
	}
	var updateobj = document.getElementById("Update");
	if (updateobj) {
        $(updateobj).bind("click", function() { return false })
        updateobj.disabled = true;
    }
	var selNum=0,selIndex=0;
	var nameObj=$("#TempTableNameList")[0];
	for (var i=0;i<nameObj.length;i++){
		if (nameObj[i].selected==true){
			selNum=parseInt(selNum)+1;
			selIndex=i;
		}
	}
	if (selNum>1){
		$.messager.alert("提示","只能选择一个表进行修改!");
		return false;
	}else if(selNum==0){
		$.messager.alert("提示","请选中需要修改的表名!");
		return false;
	}
	var NewTableName=$.trim($("#selTabName").val());
	if (NewTableName===""){
		$.messager.alert("提示","修改后的表名不能为空!","info",function(){
			$("#selTabName").focus();
		});
		return false;
	}else{
		if (PageLogicObj.pattern.test(NewTableName)){
			$.messager.alert("提示","修改后的表名【"+NewTableName+"】含有非法字符!","info",function(){
				$("#selTabName").focus();
			});
			return false;
		}
	}
	var NameGroupRepeatFlag=0;
	var arrLstItems = new Array(PageLogicObj.maxListGroupNum);
	for (var i=1;i<=PageLogicObj.maxListGroupNum;i++){
		var listGroupObj=$("#ListGroup_"+i)[0];
		var ListGroupData=new Array();
		for (var m=0;m<listGroupObj.length;m++){
			var ItemID=listGroupObj[m].value;
			if(ItemID!="") {
				ItemID=ItemID.replace("Y","");
				ItemID=ItemID.replace("NewAddItem","");
			}
			ListGroupData.push(ItemID);
		}
		var NameGroup=$("#NameGroup_"+i).val();
		if (NameGroup!=""){
			for (var j=i+1;j<=PageLogicObj.maxListGroupNum;j++){
				var NextNameGroup=$("#NameGroup_"+j).val();
				if (NextNameGroup==NameGroup){
					NameGroupRepeatFlag=1;
					break;
				}
			}
		}else{
			if (PageLogicObj.pattern.test(NameGroup)){
				$.messager.alert("提示","表名【"+NameGroup+"】含有非法字符!","info",function(){
					$("#NameGroup_"+i).focus();
				});
				return false;
			}
		}
		arrLstItems[i-1]=NameGroup+PageLogicObj.groupitemDelim+ListGroupData.join(PageLogicObj.groupitemDelim)
	}
	if (NameGroupRepeatFlag==1){
		$.messager.alert("提示",NameGroup+" 列名重复!");
		return false;
	}
	var UpdateVal = arrLstItems.join(PageLogicObj.tabgroupDelim);
	var TableNameList=new Array();
	var RepeatFlag=0;
	for (var i=0;i<nameObj.length;i++){
		var tableName=nameObj[i].text;
		var Index=nameObj[i].value.split("!!")[1];
		if (i==parseInt(nameObj.selectedIndex)){
			tableName=NewTableName;
		}else{
			if (NewTableName==tableName){
				RepeatFlag=1;
				break;
			}
		}
		TableNameList[i]=tableName+"^"+(parseInt(Index)+1);
	}
	if (RepeatFlag==1){
		$.messager.alert("提示",NewTableName+" 表名重复!","info",function(){
			$("#selTabName").focus();
		});
		return false;
	}
    TableNameList=TableNameList.join("!!");
    var objectType=ServerObj.PreftabType;
	var AppKey="ORDER";
	if (ServerObj.CMFlag=="CM"){
		AppKey=AppKey+ServerObj.CMDefaultContext;
	}else{
		AppKey=AppKey+ServerObj.XYDefaultContext;
	}
	if (ServerObj.PreftabType=="User.SSUser"){
		var objectReference=session['LOGON.USERID'];
		AppKey=AppKey+ServerObj.LocPrefType;
		AppKey=AppKey+"_HospDr"+session['LOGON.HOSPID'];
	}else{
		var objectReference=session['LOGON.CTLOCID'];
	}
	$.m({
	    ClassName:"web.DHCDocPrefTabs",
	    MethodName:"websysSaveOETabsNew",
	    id:PageLogicObj.websysPrefId,
	    objectType:objectType,
	    objectReference:objectReference,
	    AppKey:AppKey,
	    TableNameList:TableNameList,
	    SelTabNameIndex:parseInt(nameObj[nameObj.selectedIndex].value.split("!!")[1])+1,
	    UpdateVal:UpdateVal
	},function(Rtn){
		var rtn=Rtn.split("^")[0];
	    var id=Rtn.split("^")[1];
		if (rtn=="0"){
			$.messager.show({
				title:'提示',
				msg:'更新成功！'
			});
			PageLogicObj.websysPrefId=id;
			LoadTempData(selIndex);
		}else{
			$.messager.alert("提示","更新失败!");
		}
		updateobj.disabled = false;
	});
}
function DeleteOrdItemHandle(){
	if ($("#DeleteOrdItem").hasClass('l-btn-disabled')){
		return false;
	}
	if ($(".list-group-select").length==0){
		$.messager.alert("提示","请选中需要删除的数据!");
		return false;
	}
	var selValArr=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex).val();
	if ((!selValArr)||(selValArr.length==0)){
		$.messager.alert("提示","请选中需要删除的数据!");
		return false;
	}
	var length=selValArr.length;
	var ListGroupObj=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex)[0];
	for (var i=ListGroupObj.length-1;i>=0;i--){
		if (ListGroupObj.options[i].selected == true) {
			ListGroupObj.remove(i);
		}
	}
}

function CopyOrdItemHandle(){
	var DiagnosStr = 'DHCCA';
	for(var k=1;k<=PageLogicObj.maxListGroupNum;k++){
		var obj=$("#ListGroup_"+k);
		var length=obj[0].options.length;
		if(length>0){ 
			for(var index=0;index<length;index++)  {
				if(obj[0].options[index].selected){
					var value=obj[0].options[index].value;
					var desc=obj[0].options[index].text;
					var lu=value.split(PageLogicObj.itemdataDelim);
					var type=lu[0],code=lu[1],notes=lu[2];
					if ((value != '') & (desc != '')) {
						DiagnosStr = DiagnosStr + "@@" + desc +'^'+code+'^'+type+"^"+notes;
					}
				}
			}
		}
	}
	if(DiagnosStr=='DHCCA') {
	 	$.messager.alert("提示","请选择需要复制的项目!");
	 	return false;
    }
    $.cm({
	    ClassName:"web.DHCDocPrefTabs",
	    MethodName:"SetTemplClipBoradrData",
	    UserID:session['LOGON.USERID'],
	    ClipBoradrData:DiagnosStr,
	    dataType:"text"
	},function(){
		$.messager.alert("提示","复制成功!","info",function(){
	        if ($("#CMTemp_Radio").checkbox('getValue')){
		        PageLogicObj.m_LastType="CM";
		    }else{
			    PageLogicObj.m_LastType="";
			}
		});
	});
	/*if(window.clipboardData) {   
        window.clipboardData.clearData();   
        window.clipboardData.setData("Text", DiagnosStr);
        $.messager.alert("提示","复制成功!","info",function(){
	        if ($("#CMTemp_Radio").checkbox('getValue')){
		        PageLogicObj.m_LastType="CM";
		    }else{
			    PageLogicObj.m_LastType="";
			}
	    });
        
    }*/
}
function PasteOrdItemHandle(){
	if ($("#PasteOrdItem").hasClass('l-btn-disabled')){
		return false;
	}
	var value=$("#CMTemp_Radio").checkbox('getValue');
	if (value){
		if (PageLogicObj.m_LastType!="CM"){
			$.messager.alert("提示","复制的是西医模板不能粘贴到草药模板!");
			return false;
		}
	}else{
		if (PageLogicObj.m_LastType!=""){
			$.messager.alert("提示","复制的是草药模板不能粘贴到西医模板!");
			return false;
		}
	}
	var PasteText=$.cm({
	    ClassName:"web.DHCDocPrefTabs",
	    MethodName:"GetTemplClipBoradrData",
	    UserID:session['LOGON.USERID'],
	    dataType:"text"
	},false);
	 //var PasteText=window.clipboardData.getData("text");
	 var PasteArray=PasteText.split("@@");
	 if (PasteArray[0]!='DHCCA'){
		 $.messager.alert("提示","粘贴板里面的内容不是使用<复制医嘱>获得的数据");
		 return false;
	 }
	 for(var i=1;i<PasteArray.length;i++){
		 debugger;
		var lu=PasteArray[i].split("^");
		var Desc=lu[0];
		var value=lu[1];
		var type=lu[2];
		var notes=lu[3];
		var code = type+PageLogicObj.itemdataDelim+value+PageLogicObj.itemdataDelim+notes;
		var ListGroupObj=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex)[0];
		
		var RepeatFlag=0;
		for (var m=0;m<ListGroupObj.options.length;m++){
			if (ListGroupObj.options[m].value==code){
				var ret=dhcsys_confirm(Desc+" 项目已存在! 是否继续?",false);
				if(!ret){
					RepeatFlag=1;
				}else{
					RepeatFlag=2;
				}
				break;
			}
		}
		if (RepeatFlag==1){
	    	break;
	    }else if (RepeatFlag==2){
		   // continue;
		}else{
		    ListGroupObj.add(new Option(Desc, code));
		}
		//ListGroupObj.add(new Option(Desc, code));
	}
	$.messager.alert("提示","粘贴结束");
}
function CopyAllOrdItemHandle(){
	var DiagnosStr="";
	for(var k=1;k<=PageLogicObj.maxListGroupNum;k++){
		var desc=$("#NameGroup_"+k).val();
		if (DiagnosStr=="") DiagnosStr=desc;
		else DiagnosStr=DiagnosStr+"@@"+desc;
	}
	DiagnosStr=DiagnosStr + 'DHCCCDHCCA';
	for(var k=1;k<=PageLogicObj.maxListGroupNum;k++){
		var listGroupObj=$("#ListGroup_"+k)[0];
		for(i=0;i<listGroupObj.length;i++){
			var value=listGroupObj[i].value;
			var text=listGroupObj[i].text;
			var lu=value.split(PageLogicObj.itemdataDelim);
			var type=lu[0],code=lu[1],notes=lu[2];;
			if ((value != '') & (text != '')) {
				DiagnosStr = DiagnosStr + "@@" + text +'^'+code+'^'+type+"^"+notes;
			}
		}
		DiagnosStr = DiagnosStr + "DHCCBDHCCA";
	}
	$.cm({
	    ClassName:"web.DHCDocPrefTabs",
	    MethodName:"SetTemplClipBoradrData",
	    UserID:session['LOGON.USERID'],
	    ClipBoradrData:DiagnosStr,
	    dataType:"text"
	},function(){
		$.messager.alert("提示","复制成功!","info",function(){
	        if ($("#CMTemp_Radio").checkbox('getValue')){
		        PageLogicObj.m_LastType="CM";
		    }else{
			    PageLogicObj.m_LastType="";
			}
		});
	});
	/*if(window.clipboardData) {   
         window.clipboardData.clearData();   
         window.clipboardData.setData("Text", DiagnosStr);
         $.messager.alert("提示","复制成功");
         if ($("#CMTemp_Radio").checkbox('getValue')){
	        PageLogicObj.m_LastType="CM";
	    }else{
		    PageLogicObj.m_LastType="";
		}
    }*/
}
function PasteAllOrdItemHandle(){
	if ($("#PasteAllOrdItem").hasClass('l-btn-disabled')){
		return false;
	}
	var value=$("#CMTemp_Radio").checkbox('getValue');
	if (value){
		if (PageLogicObj.m_LastType!="CM"){
			$.messager.alert("提示","复制的是西医模板不能粘贴到草药模板!");
			return false;
		}
	}else{
		if (PageLogicObj.m_LastType!=""){
			$.messager.alert("提示","复制的是草药模板不能粘贴到西医模板!");
			return false;
		}
	}
	var PasteText=$.cm({
	    ClassName:"web.DHCDocPrefTabs",
	    MethodName:"GetTemplClipBoradrData",
	    UserID:session['LOGON.USERID'],
	    dataType:"text"
	},false);
	//var PasteText=window.clipboardData.getData("text");
	var PasteHead=PasteText.split("DHCCC");
	if (PasteText.indexOf('DHCCCDHCCA')==-1){
		$.messager.alert("提示","粘贴板里面的内容不是使用<复制全部医嘱>获得的数据");
		return false;
	}
	var PasteHeadItem=PasteHead[0].split("@@");
	for(var k=1;k<=PageLogicObj.maxListGroupNum;k++){
		$("#NameGroup_"+k).val(PasteHeadItem[k-1]);
	}
	var PasteAllArray=PasteHead[1].split("DHCCB");
	for (var k = 0; k < PasteAllArray.length; k++) {
		var Pasteitem=PasteAllArray[k]
		var PasteArray=Pasteitem.split("@@");
		if (PasteArray[0]!='DHCCA'){
			$.messager.alert("提示","粘贴板里面的内容不是科室诊断");
			return false;
		}
		if (k>5) return false;
		for(var i=1;i<PasteArray.length;i++){
 			var lu=PasteArray[i].split("^");
			var desc=lu[0];
			var value=lu[1];
			var type=lu[2];
			var notes=lu[3];
			code = type+PageLogicObj.itemdataDelim+value+PageLogicObj.itemdataDelim+notes;
			var index=parseInt(k)+1;
			var ListGroupObj=$("#ListGroup_"+index)[0];
			var RepeatFlag=0;
			for (var m=0;m<ListGroupObj.options.length;m++){
				if (ListGroupObj.options[m].value==code){
					var ret=dhcsys_confirm(desc+" 项目已存在! 是否继续?",false);
					if(!ret){
						RepeatFlag=1;
					}else{
						RepeatFlag=2;
					}
					break;
				}
			}
			if (RepeatFlag==1){
		    	break;
		    }else if (RepeatFlag==2){
			   // continue;
			}else{
			    ListGroupObj.add(new Option(desc, code));
			}
 		}
	}
	$.messager.alert("提示","粘贴结束");
}

function BodykeydownHandler(e){
	if (window.event){
		var keyCode=window.event.keyCode;
		var type=window.event.type;
		var SrcObj=window.event.srcElement;
	}else{
		var keyCode=e.which;
		var type=e.type;
		var SrcObj=e.target;
	}
	//回车事件或者
	if (keyCode==13) {
		if (SrcObj && SrcObj.id=="NewTabName") {
			AddTableClickHandle();
			return false;
		}
	}
}
function PreftabTypeClickHandle(e,value){
	ChangeStatus(false);
	if (e.target.value=="User.SSUser"){
		if (e.target.checked) ServerObj.PreftabType="User.SSUser";
	}else{
		ServerObj.PreftabType="User.CTLoc";
		//无科室维护权限
		if (ServerObj.IsHaveMenuAuthOrderOrgFav!="1"){
			ChangeStatus(true);
		}
	}
	ContinonsChange();
}
function CMCheckClickHandle(e,value){
	if (e.target.checked) {
		ServerObj.CMFlag="CM";
	}else{
		ServerObj.CMFlag="";
	}
	ContinonsChange();
	$("#OrdCategory").combobox('reload');
}
function ContinonsChange(){
	$("#EditTip")[0].innerHTML="";
	$("#OrdCategory,#OrdSubCategory").combobox('select','');
	SetContext();
	LoadTempData();
	SetSaveParamText();
	SetSaveParaTip();
}
function SetSaveParamText(){
	if (ServerObj.PreftabType=="User.SSUser"){
		ServerObj.SaveParam=session['LOGON.USERNAME'];
	}else{
		ServerObj.SaveParam=ServerObj.LogCTLocDesc;
	}
	SetContext();
	if (ServerObj.Context===""){
		ServerObj.SaveParam=ServerObj.SaveParam;
	}else{
		ServerObj.SaveParam=ServerObj.SaveParam+"+"+ServerObj.Context;
	}
	$("#SaveParamText")[0].innerHTML=ServerObj.SaveParam
}
function SetSaveParaTip(){
	var tips="正在维护 ";
	if (ServerObj.CMFlag=="CM"){
		tips=tips+"中医";
	}else{
		tips=tips+"西医";
	}
	if (ServerObj.PreftabType=="User.SSUser"){
		tips=tips+"个人";
	}else{
		tips=tips+"科室";
	}
	tips=tips+"模板";
	$("#SaveParaTip")[0].innerHTML=tips;
}
function SetContext(){
	if (ServerObj.CMFlag=="CM"){
	    ServerObj.Context=ServerObj.CMDefaultContext;
	}else{
		ServerObj.Context=ServerObj.XYDefaultContext;
	}
	if (ServerObj.PreftabType=="User.SSUser"){
		var key="ORDER"+ServerObj.Context+ServerObj.LocPrefType;
	}else{
		var key="ORDER"+ServerObj.Context;
	}
    ServerObj.Context=key;
}
function AddTableClickHandle(){
	if ($("#AddTable").hasClass('l-btn-disabled')){
		return false;
	}
	var tableName=$.trim($("#NewTabName").val());
	if (tableName==""){
		$.messager.alert("提示","请输入新表名称!","info",function(){
			$("#NewTabName").val('').focus();
		});
		return false;
	}else{
		if (PageLogicObj.pattern.test(tableName)){
			$.messager.alert("提示","新表名称【"+tableName+"】含有非法字符!","info",function(){
				$("#NewTabName").focus();
			});
			return false;
		}
	}
	var nameListObj=$("#TempTableNameList")[0];
	for (var i=0;i<nameListObj.options.length;i++){
		if (tableName==nameListObj.options[i].text){
			$.messager.alert("提示","新表名称: "+tableName+" 已存在!","info",function(){
				$("#NewTabName").focus();
			});
			return false;
		}
	}
	nameListObj.options.selectedIndex=-1;
	nameListObj.add(new Option(tableName, ""+"!!"+(nameListObj.length)));
	var length=nameListObj.length-1;
	nameListObj.options[length].selected=true;
	PageLogicObj.TableNameSelectIndex=length;
	$("#selTabName").val(tableName);
	//成功添加之后清空表名字
	$("#NewTabName").val("");
	ClearListGroupData();
	$("#OrdCategory").focus();
}
function DeleteTableClickHandle(){
	if ($("#DeleteTable").hasClass('l-btn-disabled')){
		return false;
	}
	var SelTabIndex="";
	var selValArr=$("#TempTableNameList").val();
	var length=selValArr.length;
	if (length==0){
		$.messager.alert("提示","请选中需要删除的表名!");
		return false;
	}
	var NameStr="";
	var nameListObj=$("#TempTableNameList")[0];
	for (var i=0;i<nameListObj.length;i++){
		if (nameListObj.options[i].selected == true) {
			if (NameStr=="") NameStr=nameListObj.options[i].text;
			else NameStr=NameStr+"、"+nameListObj.options[i].text;
		}
	}
	$.messager.confirm('确认对话框', '确定删除模板 '+NameStr+" 下所有内容吗?", function(r){
		if (r){
			for (var i=nameListObj.length-1;i>=0;i--){
				if (nameListObj.options[i].selected == true) {
					nameListObj.remove(i);
					var index=parseInt(i)+1;
					if (SelTabIndex=="") SelTabIndex=index;
					else SelTabIndex=SelTabIndex+"^"+index;
				}
			}
		    $.m({
			    ClassName:"web.DHCDocPrefTabs",
			    MethodName:"websysDelOETabsNew",
			    id:PageLogicObj.websysPrefId,
			    SelTabIndex:SelTabIndex
			},function(val){
				if (val=="0"){
					$.messager.alert("提示","删除成功!");
					$("#selTabName").val("");
					$("#EditTip")[0].innerHTML="";
					ClearListGroupData();
					var length=$("#TempTableNameList")[0].length-1;
					if (length>=0){
						$("#TempTableNameList").get(0).selectedIndex=length;
						PageLogicObj.TableNameSelectIndex=length;
						LoadTempData(length);
						//$("#selTabName").val(tableName);
						//SelTabName();
					}
				}else{
					$.messager.alert("提示","删除失败!");
					return false;
				}
			});
		}
	});
}
function listbox_move(id,listID,direction){
	if ($("#"+id).hasClass('l-btn-disabled')){
		return false;
	}
	var listbox = document.getElementById(listID);
    var selIndex = listbox.selectedIndex;
    if(-1 == selIndex) {
	    $.messager.alert("提示","请选择需要移动的数据!");
        return;
    }
    var increment = -1;
    if(direction == 'up')
        increment = -1;
    else
        increment = 1;
    if((selIndex + increment) < 0 ||
        (selIndex + increment) > (listbox.options.length-1)) {
        return;
    }
    var selValue = listbox.options[selIndex].value;
    var selText = listbox.options[selIndex].text;
    listbox.options[selIndex].value = listbox.options[selIndex + increment].value
    listbox.options[selIndex].text = listbox.options[selIndex + increment].text
    listbox.options[selIndex].title = listbox.options[selIndex + increment].title
    listbox.options[selIndex + increment].value = selValue;
    listbox.options[selIndex + increment].text = selText;
    listbox.options[selIndex + increment].title = selText;
    listbox.selectedIndex = selIndex + increment
}
function listboxMoveacross(id,sourceID, destID) { 
	if ($("#"+id).hasClass('l-btn-disabled')){
		return false;
	}
    var src = document.getElementById(sourceID); 
    var dest = document.getElementById(destID); 
    if (!dest) return false;
    for(var count=0; count < src.options.length; count++) { 
        if(src.options[count].selected == true) { 
            var option = src.options[count];
            for(var m=0; m < dest.options.length; m++) { 
            	if (dest.options[m].value==option.value){
	            	$.messager.alert("提示",option.text+" 项目已存在!");
	            	return false;
	            }
            }
            var newOption = document.createElement("option"); 
            newOption.value = option.value; 
            newOption.text = option.text; 
            newOption.selected = true; 
            try { 
                     dest.add(newOption, null); //Standard 
                     src.remove(count, null); 
             }catch(error) { 
                     dest.add(newOption); // IE only 
                     src.remove(count); 
             } 
            count--; 
        } 
    } 
    ListGroupClickHandle(destID);
} 
function ListGroupClickHandle(id){
	$(".list-group-select").removeClass("list-group-select");
	$(".name-group-select").removeClass("name-group-select");
	$("#"+id+"").addClass("list-group-select");
	var index=id.split("_")[1];
	PageLogicObj.listGroupSelectIndex=index;
	$("#NameGroup_"+index+"").addClass("name-group-select");
	$("#EditTip")[0].innerHTML="正在编辑列 "+$("#NameGroup_"+index+"").val();
	//var title="医嘱模板数据维护 "+'<span style="color:red;font-size:16px;">'+"正在编辑列 "+$("#NameGroup_"+index+"").val()+'</span>';
	//$('#Ordlayout_main').panel('setTitle',title);
}
function NameGroupClickHandle(id){
}
function LoadTempData(selIndex){
	if (typeof selIndex=="undefined") selIndex=0;
	$("#selTabName").val("");
	$("#TempTableNameList").empty();
	ClearListGroupData();
	var objectType=ServerObj.PreftabType;
	var AppKey="ORDER";
	if (ServerObj.CMFlag=="CM"){
		AppKey=AppKey+ServerObj.CMDefaultContext;
	}else{
		AppKey=AppKey+ServerObj.XYDefaultContext;
	}
	var AppSubKey=AppKey;
	if (ServerObj.PreftabType=="User.SSUser"){
		var objectReference=session['LOGON.USERID'];
		AppSubKey=AppSubKey+ServerObj.LocPrefType;
		AppSubKey=AppSubKey+"_HospDr"+session['LOGON.HOSPID'];
	}else{
		var objectReference=session['LOGON.CTLOCID'];
	}
	$.m({
		ClassName:"web.DHCDocPrefTabs",
		MethodName:"GetOETabItems",
		objtype:objectType,
		objvalue:objectReference,
		Key:AppSubKey
	},function(allTabs){
		var websysPrefId=allTabs.split("!!")[1];
		PageLogicObj.websysPrefId=websysPrefId;
		if (allTabs.split("!!")[0]!="") {
			var nameListObj=$("#TempTableNameList")[0];
			var tabgroups=allTabs.split("!!")[0].split(",");
			for (var i=0;i<tabgroups.length;i++){
				var desc=tabgroups[i].split("@")[0]; 
				var value=tabgroups[i].split("@")[1]; 
				nameListObj.add(new Option(desc, value+"!!"+i));
      			if (i==selIndex){
	      			nameListObj.options[i].selected=true;
				    PageLogicObj.TableNameSelectIndex=i;
	      			$("#selTabName").val(desc);
	      		}
			}
			if ($("#TempTableNameList")[0].length>0) {
				SelTabName();
			}
		}
	})
}
function SelTabName(){
	ClearListGroupData();
	var dataDetail=$("#TempTableNameList").val()[0].split("!!")[0];
	for (var i=0;i<dataDetail.split(PageLogicObj.groupitemDelim).length;i++){
		var tmpNameGroup=dataDetail.split(PageLogicObj.groupitemDelim)[i].split(":")[0];
		var tmpListGroupData=dataDetail.split(PageLogicObj.groupitemDelim)[i].slice(1) //split(":")[1];
		if ((tmpListGroupData=="")||(tmpListGroupData==undefined)) continue;
		var NameIndex=parseInt(i)+1;
		$("#NameGroup_"+NameIndex).val(tmpNameGroup);
		var ListGroupObj=$("#ListGroup_"+NameIndex)[0];
		for (j=0;j<tmpListGroupData.split("^").length;j++){
			var onegroup=tmpListGroupData.split("^")[j];
			var Desc=onegroup.split("!")[1].split(PageLogicObj.itemdataDelim)[1];
			var title=Desc;
			var OrdType=onegroup.split("!")[1].split(PageLogicObj.itemdataDelim)[2];
			var itemrowid=onegroup.split("!")[1].split(PageLogicObj.itemdataDelim)[3];
			var itemNotes=onegroup.split("!")[1].split(PageLogicObj.itemdataDelim)[5];
			if (itemNotes!="") {
				Desc=Desc+"**"+itemNotes;
			}
	        var value=OrdType+PageLogicObj.itemdataDelim+itemrowid+PageLogicObj.itemdataDelim+itemNotes;
	        if ((value==undefined)||(Desc==undefined)||(value=="")||(Desc==""))continue;
	        ListGroupObj.add(new Option(Desc, value));
	        ListGroupObj.options[ListGroupObj.length-1].title=title;
		}
		/*$("#ListGroup_"+NameIndex+" option").dblclick(function () {
	         OpenOrdItemNotesDialog(this);
	    })*/
	}
	if ($(".list-group-select").length>0){
		var selId=$(".list-group-select")[0].id;
		var index=selId.split("_")[1];
		$("#EditTip")[0].innerHTML="正在编辑列 "+$("#NameGroup_"+index+"").val();
	}
}
function ClearListGroupData(){
	for (var i=1;i<=PageLogicObj.maxListGroupNum;i++){
		$("#ListGroup_"+i).empty();
		$("#NameGroup_"+i).val("");
	}
}
function InitOrdCategory(){
   var GroupID=session['LOGON.GROUPID'];
   $("#OrdCategory").combobox({
		url:$URL+"?ClassName=web.OECOrderCategory&QueryName=LookUpBySSGroup",
        mode:'remote',
        method:"Get",
		valueField: 'HIDDEN', 
		textField: 'Description',
		editable:true,
		onBeforeLoad:function(param){
	        var desc=param['q'];
			param = $.extend(param,{Category:desc,SSGRP:GroupID});
	    },
	    loadFilter:function(data){
		    var CMFlag="XY";
		    if (ServerObj.CMFlag=="CM") CMFlag=ServerObj.CMFlag;
		    var newDataArr=new Array();
		    for (var i=0;i<data['rows'].length;i++){
			    var jsondata=$.cm({
				    ClassName:"web.ARCItemCat",
				    QueryName:"LookUpByCategory",
				    SubCategory:'',
				    Category:data['rows'][i]['Description'],
				    SSGroupID:GroupID,
				    CMFlag:CMFlag,
				    rows:9999
				},false);
				if (jsondata.total>0){
					newDataArr.push({"HIDDEN":data['rows'][i]['HIDDEN'],"Description":data['rows'][i]['Description'],"Code":data['rows'][i]['Code']});
				}
			}
			return newDataArr;
		},
		onSelect:function(rec){
			if (rec!=undefined){
				OrderCategoryLookupSelect(rec['Description']+"^"+rec['HIDDEN']);
				//InitOrdSubCategory();
				$("#OrdSubCategory").combobox("reload");
			}
		},
		onChange:function(newValue,oldValue){
			if (newValue==""){
				PageLogicObj.OrdCatRowId="";
				PageLogicObj.OrdSubRowId="";
				$("#OrdSubCategory").combobox('select','');
				setTimeout(function(){$("#OrdSubCategory").combobox('reload');}) //InitOrdSubCategory();
			}
		},
		onLoadSuccess:function(){
			$("#OrdSubCategory").combobox('reload');
		}
	 });	
}
function InitOrdSubCategory(){
	var GroupID=session['LOGON.GROUPID'];
   $("#OrdSubCategory").combobox({
		url:$URL+"?ClassName=web.ARCItemCat&QueryName=LookUpByCategory",
        mode:'remote',
        method:"Get",
		valueField: 'HIDDEN', 
		textField: 'desc',
		editable:true,
		onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc==undefined) desc="";
	        var Category=$("#OrdCategory").combobox('getText');
	        var CMFlag="XY";
		    if (ServerObj.CMFlag=="CM") CMFlag=ServerObj.CMFlag;
			param = $.extend(param,{SubCategory:desc,Category:Category,SSGroupID:GroupID,CMFlag:CMFlag});
	    },
	    loadFilter:function(data){
		    return data['rows'];
		},
		onSelect:function(rec){
			if (rec){
				OrderSubCatLookupSelect(rec['desc']+"^"+rec['HIDDEN']);
			}
		},
		onChange:function(newValue,oldValue){
			if (newValue==""){
				PageLogicObj.OrdSubRowId="";
				$("#OrdItem").lookup('setText','');
			}
		}
	 });
}
function InitOrdItemLookUp(){
	$("#OrdItem").lookup({
		//width:$(window).width()-1115,
        url:$URL,
        mode:'remote',
        method:"Get",
        idField:'HIDDEN',
        textField:'ARCIMDesc',
        columns:[[  
           {field:'ARCIMDesc',title:'医嘱名称',width:320,sortable:true},
            {field:'HIDDEN',title:'ID',width:70,sortable:true}
        ]],
        pagination:true,
        panelWidth:400,
        panelHeight:400,
        isCombo:true,
        minQueryLen:2,
        delay:'500',
        queryOnSameQueryString:true,
        queryParams:{ClassName: 'web.DHCDocOrderEntry',QueryName: 'LookUpItem'},
        onBeforeLoad:function(param){
	        var desc=param['q'];
	        if (desc=="") return false;
	        var CurLogonDep = session['LOGON.CTLOCID'];
			var GroupID = session['LOGON.GROUPID'];
			var OrdCatRowId=PageLogicObj.OrdCatRowId;
			var OrdSubRowId=PageLogicObj.OrdSubRowId;
			var P5 = "";
		    var LogonDep = ""
		    var OrderPriorRowid = "";
		    var P9 = "",P10 = "";
		    var OrdCatGrp = "";
			if (ServerObj.CMFlag=="CM"){
		        var CMFlag="CM";
		    }else{
			    var CMFlag="XY";
			}
			var NonFormulary="NonFormAndBrand"+"^"+CMFlag;
		
			param = $.extend(param,{Item:desc,GroupID:session['LOGON.GROUPID'],Category:OrdCatRowId,SubCategory:OrdSubRowId,TYPE:P5,OrderDepRowId:LogonDep, OrderPriorRowId:OrderPriorRowid, EpisodeID:"", BillingGrp:P9, BillingSubGrp:P10, UserRowId:session["LOGON.USERID"], OrdCatGrp:OrdCatGrp, NonFormulary:NonFormulary, Form:CurLogonDep});
	    },onSelect:function(ind,item){
		   var txt=item['ARCIMDesc']+"^"+item['HIDDEN']+"^"+item['HIDDEN1']+"^"+item['HIDDEN2'];
		   OrderLookupSelect(txt);
		   setTimeout(function(){$("#OrdItem").lookup('setText','');})
		}
    });
}
/*function LookUpItem(e){
	var id=e.target.id;
	if ((id=="OrdCategory")||(id=="imgOrdCategory")){
		OrdCategoryLookUpItem(e);
	}
	if ((id=="OrdSubCategory")||(id=="imgOrdSubCategory")){
		OrdSubCategoryLookUpItem(e);
	}
	if ((id=="OrdItem")||(id=="imgOrdItem")){
		OrdItemLookUpItem(e);
	}
}
var OrdCatItemzLookupGrid;
function OrdCategoryLookUpItem(e){
	try{
		var obj=websys_getSrcElement(e);
		var type=websys_getType(e);
		var key=websys_getKey(e);
		var OrderName=$("#OrdCategory").val().replace(/(^\s*)|(\s*$)/g,'');
		if ((key == 13) || (type == 'dblclick')||(obj.id == 'imgOrdCategory')||((OrderName.length>0)&&(key>64 && key<91))) {
	        var GroupID=session['LOGON.GROUPID']
			var ChoseType=""
			var mobj=document.getElementById("ChoseType");
			if ((mobj)&&(mobj.checked)){ChoseType="on"}
	        
	        if (OrdCatItemzLookupGrid && OrdCatItemzLookupGrid.store) {
		        OrdCatItemzLookupGrid.searchAndShow([function() { return $(obj).val(); }, GroupID, ChoseType]);
		    } else {
		        OrdCatItemzLookupGrid = new dhcc.icare.Lookup({
		            lookupListComponetId: 1872,
		            lookupPage: "医嘱大类选择",
		            lookupName: "OrdCategory",
		            listClassName: 'web.OECOrderCategory',
		            listQueryName: 'LookUpBySSGroup',
		            resizeColumn: false,
		            listProperties: [function() { return $(obj).val(); }, GroupID, ChoseType],
		            listeners: { 
		                'selectRow': OrderCategoryLookupSelect
		            },
		            isCombo: true
		        });
		    }
	    }
   }catch(e){}
}*/
function OrderCategoryLookupSelect(value){
	PageLogicObj.OrdCatRowId=value.split("^")[1];
	PageLogicObj.OrdSubRowId="";
	$("#OrdSubCategory").combobox('select','');
	$("#OrdItem").lookup('setText','');
	$('#OrdSubCategory').next('span').find('input').focus();
}
/*var OrdSubCatItemzLookupGrid;
function OrdSubCategoryLookUpItem(e){
	try{
		var obj=websys_getSrcElement(e);
		var type=websys_getType(e);
		var key=websys_getKey(e);
		var OrdCatgoryDesc=$("#OrdCategory").val(); 
		var OrdSubCatDesc=$("#OrdSubCategory").val(); 
        var GroupID=session['LOGON.GROUPID'];
        if (ServerObj.CMFlag=="CM"){
	        var CMFlag="CM";
	    }else{
		    var CMFlag="XY";
		}
        if ((key == 13) || (type == 'dblclick')||(obj.id == 'imgOrdSubCategory')||((OrdSubCatDesc.length>0)&&(key>64 && key<91))) {
	        if (OrdSubCatItemzLookupGrid && OrdSubCatItemzLookupGrid.store) {
		        OrdSubCatItemzLookupGrid.searchAndShow([function() { return $("#OrdSubCategory").val(); }, OrdCatgoryDesc,GroupID,CMFlag]);
		    } else {
		        OrdSubCatItemzLookupGrid = new dhcc.icare.Lookup({
		            lookupListComponetId: 1872,
		            lookupPage: "医嘱子类选择",
		            lookupName: "OrdSubCategory",
		            listClassName: 'web.ARCItemCat',
		            listQueryName: 'LookUpByCategory',
		            resizeColumn: false,
		            listProperties: [function() { return $("#OrdSubCategory").val(); }, OrdCatgoryDesc,GroupID,CMFlag],
		            listeners: { 
		                'selectRow': OrderSubCatLookupSelect
		            },
		            isCombo: true
		        });
		    }
	    }
	}catch(e){}
}*/
function OrderSubCatLookupSelect(value){
	PageLogicObj.OrdSubRowId=value.split("^")[1];
	$("#OrdItem").lookup('setText','').focus();
}
/*var ItemzLookupGrid;
function OrdItemLookUpItem(e){
	try{
		var obj=websys_getSrcElement(e);
		var type=websys_getType(e);
		var key=websys_getKey(e);
		var CurLogonDep = session['LOGON.CTLOCID'];
		var GroupID = session['LOGON.GROUPID'];
		var OrdCatRowId=PageLogicObj.OrdCatRowId;
		var OrdSubRowId=PageLogicObj.OrdSubRowId;
		var P5 = "";
	    var LogonDep = ""
	    var OrderPriorRowid = "";
	    var P9 = "",P10 = "";
	    var OrdCatGrp = "";
		var OrdNameDesc=$("#OrdItem").val(); 
		if (ServerObj.CMFlag=="CM"){
	        var CMFlag="CM";
	    }else{
		    var CMFlag="XY";
		}
		var NonFormulary="NonFormAndBrand"+"^"+CMFlag;
		if ((key == 13) || (type == 'dblclick')||(obj.id == 'imgOrdItem')||((OrdNameDesc.length>0)&&(key>64 && key<91))) {
	        if (ItemzLookupGrid && ItemzLookupGrid.store) {
		        ItemzLookupGrid.searchAndShow([function() { return $("#OrdItem").val(); }, GroupID, OrdCatRowId, OrdSubRowId, P5, LogonDep, OrderPriorRowid, "", P9, P10, session["LOGON.USERID"], OrdCatGrp, NonFormulary, CurLogonDep]);
		    } else {
		        ItemzLookupGrid = new dhcc.icare.Lookup({
		            lookupListComponetId: 1872,
		            lookupPage: "医嘱选择",
		            lookupName: "OrdItem",
		            listClassName: 'web.DHCDocOrderEntry',
		            listQueryName: 'LookUpItem',
		            resizeColumn: false,
		            listProperties: [function() { return $("#OrdItem").val(); }, GroupID, OrdCatRowId, OrdSubRowId, P5, LogonDep, OrderPriorRowid, "", P9, P10, session["LOGON.USERID"], OrdCatGrp, NonFormulary, CurLogonDep],
		            listeners: { 
		                'selectRow': OrderLookupSelect
		            },
		            isCombo: true
		        });
		    }
		}
	}catch(e){}
}*/
function OrderLookupSelect(value){
	var OrdNameRowId=value.split("^")[1];
	var OrdNameDesc=value.split("^")[0];
	var OrdType=value.split("^")[3];
	var value=OrdType+PageLogicObj.itemdataDelim+OrdNameRowId;
	if (OrdType=="ARCIM"){
		var ItemServiceFlag = $cm({
			ClassName:"web.DHCDocOrderCommon",
			MethodName:"GetItemServiceFlag",
			InStr:OrdNameRowId
		},false);
		if (ItemServiceFlag=="1"){
			var isExistPart=$cm({
				ClassName:"web.DHCAPPInterface",
				MethodName:"isExistPart",
				itmmastid:OrdNameRowId,
				dataType:"text"
			},false);
			if (isExistPart=="1"){
				/*var linkUrl = "dhcapp.appreppartwin.csp?itmmastid="+OrdNameRowId;
				var reppartStr=window.showModalDialog(linkUrl,"","dialogwidth:800px;dialogheight:600px;status:no;center:1;resizable:yes");
				//部位、体位和后处理描述串^部位和体位串^后处理ID
				if (typeof reppartStr !="undefined"){
					var reppartArr=reppartStr.split("^");
					OrdNameDesc=OrdNameDesc+reppartArr[0];
					value=value+"*S*"+reppartArr.slice(1).join("*");
				}*/
				websys_showModal({
					url:"dhcapp.appreppartwin.csp?itmmastid="+OrdNameRowId,
					title:OrdNameDesc+' 部位选择',
					width:800,height:600,
					CallBackFunc:function(reppartStr){
						var reppartArr=reppartStr.split("^");
						OrdNameDesc=OrdNameDesc+reppartArr[0];
						value=value+"*S*"+reppartArr.slice(1).join("*");
						AddToListGroup();
					},
					onClose:function(){
						if (value.indexOf("*S*")<0) {
							AddToListGroup();
						}
					}
				})
			}else{
				AddToListGroup();
			}
		}else{
			AddToListGroup();
		}
	}else{
		AddToListGroup();
	}
	function AddToListGroup(){
		value=value+PageLogicObj.itemdataDelim+"NewAddItem";
		var ListGroupObj=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex)[0];
		for (var i=0;i<ListGroupObj.options.length;i++){
			if (ListGroupObj.options[i].value.split(PageLogicObj.itemdataDelim)[1]==value.split(PageLogicObj.itemdataDelim)[1]){
				$.messager.alert("提示",OrdNameDesc+" 项目已存在!","info",function(){
					$("#OrdItem").lookup('setText','').focus();
				});
				return false;
			}
		}
		ListGroupObj.add(new Option(OrdNameDesc, value));
		ListGroupObj.options[ListGroupObj.length-1].title=OrdNameDesc;
		$("#OrdItem").lookup('setText','');
	}
}
function ReSetWidth(){
	var ww=$("#Ordlayout_main").width();
	$(".name-group").css('width',ww/5-21);
	$(".list-group").css('width',ww/5-13);
	$("#OrdItem").lookup('resize',ww/5-53);
	$("#selTabName").css('width',ww/5-21-34);
	$("#OrdCategory").combobox('resize',ww/5-21-33);
	$("#OrdSubCategory").combobox('resize',ww/5-21-48);
	$("#EditTip").parent().css('width',ww-55)
	$("#TempTableNameList").css('height',$(window).height()-280);
	$(".list-group").css('height',$(window).height()-262);
}
function ChangeStatus(disabled){
	if (disabled){
		$HUI.linkbutton(".hisui-linkbutton").disable();
		$("#OrdCategory,#OrdSubCategory").combobox('disable');
		$("#OrdItem").lookup('disable');
		$("#NewTabName,#selTabName").prop("disabled",true);
		$HUI.linkbutton("#CopyOrdItem,#CopyAllOrdItem").enable();
	}else{
		$HUI.linkbutton(".hisui-linkbutton").enable();
		$("#OrdCategory,#OrdSubCategory").combobox('enable');
		$("#OrdItem").lookup('enable');
		$("#NewTabName,#selTabName").prop("disabled",false);
	}
}
function OpenOrdItemNotesDialog(obj){
	if (PageLogicObj.websysPrefId=="") return;
	var value=obj.value;
	if (value=="") return;
	var OrdType=value.split(PageLogicObj.itemdataDelim)[0];
	if (OrdType=="ARCOS") return;
	if (value.split(PageLogicObj.itemdataDelim)[2]=="NewAddItem") {
		$.messager.alert("提示","请先点击【保存】后再维护备注!");
		return;
	}
	var _$SelTabName=$('#TempTableNameList').find("option:selected");
	var oldTabValue=_$SelTabName.val();
	var oldDataDetail=oldTabValue.split("!!")[0];
	var oldDataDetailArr=oldDataDetail.split(PageLogicObj.groupitemDelim);
	var oldNameGroupData=oldDataDetailArr[PageLogicObj.listGroupSelectIndex-1];
	var oldNameGroupDataArr=oldNameGroupData.split("::");
	var oldListGroupData=oldNameGroupDataArr[1];
	var oldListGroupDataArr=oldListGroupData.split("^");
	var OrdItemIndex=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex).get(0).selectedIndex;
	if (OrdItemIndex>=oldListGroupDataArr.length) {
		$.messager.alert("提示","请先点击【保存】后再维护备注!");
		return;
	}
	var OrdType=oldListGroupDataArr[OrdItemIndex].split(PageLogicObj.itemdataDelim)[2];
	var itemrowid=oldListGroupDataArr[OrdItemIndex].split(PageLogicObj.itemdataDelim)[3];
	var itemNotes=oldListGroupDataArr[OrdItemIndex].split(PageLogicObj.itemdataDelim)[5];
	var oldvalue=OrdType+PageLogicObj.itemdataDelim+itemrowid+PageLogicObj.itemdataDelim+itemNotes; 
	if (oldvalue!=value){
		$.messager.alert("提示","请先点击【保存】后再维护备注!");
		return;
	}
	
	var title="<span style='color:yellow;'>"+obj.title+"</span> 备注维护";
	$("#OrdItemNotes-dialog").dialog("setTitle",title).dialog("open");
	var desc=value.split(PageLogicObj.itemdataDelim)[2];
	$("#OrdItemNotes").val(desc).focus();
}
function OrdItemNotesSave(){
	var newOrdItemNotes=$.trim($("#OrdItemNotes").val());
	if ((newOrdItemNotes!="")&&(PageLogicObj.pattern.test(newOrdItemNotes))) {
		$.messager.alert("提示","备注中含有非法字符!","info",function(){
			$("#OrdItemNotes").focus();
		});
		return false;
	}
	var OrdItemIndex=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex).get(0).selectedIndex;
	var selNum=0,selIndex=0;
	var nameObj=$("#TempTableNameList")[0];
	for (var i=0;i<nameObj.length;i++){
		if (nameObj[i].selected==true){
			selNum=parseInt(selNum)+1;
			selIndex=i;
		}
	}
	if (selNum>1){
		$.messager.alert("提示","只能选择一个表进行修改!");
		return false;
	}
	var oldItemDataArr=PageLogicObj.itemdataDelim.split(PageLogicObj.itemdataDelim);
	var Rtn=tkMakeServerCall("web.DHCDocPrefTabs","websysSaveOEItemNotes",PageLogicObj.websysPrefId,parseInt(selIndex)+1,PageLogicObj.listGroupSelectIndex,parseInt(OrdItemIndex)+1,newOrdItemNotes);
	var rtn=Rtn.split("^")[0];
    var id=Rtn.split("^")[1];
	if (rtn=="0"){
		$.messager.popover({msg: '保存医嘱备注成功！',type:'success'});
		PageLogicObj.websysPrefId=id;
		$("#OrdItemNotes-dialog").dialog("close");
	    //更新option对应的value和desc
	    var _$SelOrdItem=$('#ListGroup_'+PageLogicObj.listGroupSelectIndex).find("option:selected");
		var oldVal=_$SelOrdItem.val();
		var oldValArr=oldVal.split(PageLogicObj.itemdataDelim);
		if (newOrdItemNotes!="") {
			oldValArr[2]=newOrdItemNotes;
			_$SelOrdItem.val(oldValArr.join(PageLogicObj.itemdataDelim));
			_$SelOrdItem[0].text=_$SelOrdItem[0].title+"**"+newOrdItemNotes;
		}else{
			_$SelOrdItem.val(oldValArr[0]+PageLogicObj.itemdataDelim+oldValArr[1]);
			_$SelOrdItem[0].text=_$SelOrdItem[0].title;
		}
		//更新表option对应的value
		var _$SelTabName=$('#TempTableNameList').find("option:selected");
		var oldTabValue=_$SelTabName.val();
		var oldDataDetail=oldTabValue.split("!!")[0];
		var oldDataDetailArr=oldDataDetail.split(PageLogicObj.groupitemDelim);
		var oldNameGroupData=oldDataDetailArr[PageLogicObj.listGroupSelectIndex-1];
		var oldNameGroupDataArr=oldNameGroupData.split("::");
		var oldListGroupData=oldNameGroupDataArr[1];
		var oldListGroupDataArr=oldListGroupData.split("^");
		var oldItemDataStr=oldListGroupDataArr[OrdItemIndex];
		var oldItemDataIndex=oldItemDataStr.split("!")[0];
		var oldItemData=oldItemDataStr.split("!")[1];
        var oldItemDataArr=oldItemData.split(PageLogicObj.itemdataDelim);
        oldItemDataArr[5]=newOrdItemNotes;
        var newItemData=oldItemDataArr.join(PageLogicObj.itemdataDelim);
        var newItemDataStr=oldItemDataIndex+"!"+newItemData;
        oldListGroupDataArr[OrdItemIndex]=newItemDataStr;
        var newListGroupData=oldListGroupDataArr.join("^");
        var newNameGroupData=oldNameGroupDataArr[0]+"::"+newListGroupData;
        oldDataDetailArr[PageLogicObj.listGroupSelectIndex-1]=newNameGroupData;
        var newDataDetail=oldDataDetailArr.join(PageLogicObj.groupitemDelim)+"!!"+oldTabValue.split("!!")[1];
		_$SelTabName.val(newDataDetail);
	}else{
		$.messager.alert("提示","保存医嘱备注成功！失败!");
	}
}
function ChangeOrdItemNotes(){
	if (PageLogicObj.websysPrefId=="") return;
	if ($(".list-group-select").length==0){
		$.messager.alert("提示","请选中需要维护备注的医嘱项!");
		return false;
	}
	var selValArr=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex).val();
	if ((!selValArr)||(selValArr.length==0)){
		$.messager.alert("提示","请选中需要维护备注的医嘱项!");
		return false;
	}
	var Count=0,selObj={};;
	var length=selValArr.length;
	var ListGroupObj=$("#ListGroup_"+PageLogicObj.listGroupSelectIndex)[0];
	for (var i=ListGroupObj.length-1;i>=0;i--){
		if (ListGroupObj.options[i].selected == true) {
			Count++;
			selObj=ListGroupObj.options[i];
		}
	}
	if (Count>1){
		$.messager.alert("提示","请选中一条医嘱项维护备注!");
		return false;
	}
	OpenOrdItemNotesDialog(selObj);
}