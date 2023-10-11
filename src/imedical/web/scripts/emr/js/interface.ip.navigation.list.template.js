//病种数量
var _diseaseCount=0;
//病种查询过的科室
var disSelectedLocId = "";
//病种初始化标志
var _flagInit = true;
var _flagCreate = false;
//知情告知标识 "EMR07"
var internalID = "";
$(function(){
    getNavCategoryData();
    internalID = navCategoryData[0].InternalID;
    $('#search').keyup(function(event){
        if(event.keyCode ==13){
            doSearch();
        }          
    });
    $("#selLocId").combobox({
        value:"ALL",
        valueField:"RowID",
        textField:"Desc",
        placeholder:"请选择科室查询！",
        onSelect:function(rec){
            doSearch();
        },
        onHidePanel:function(){
            var value = $("#selLocId").combobox("getValue");
            if (value == ""){
                $("#selLocId").combobox("select","ALL");
            }
        }
    });
    $("#doSearch").click(function() {
        doSearch();
    });
    $("#allTemp").checkbox({
        onChecked:function(event,val){
            $("#navcategory").css("display","none");
            $("#allTemplateNav").css("display","block");
            if($("#personal").is(':checked')) $("#personal").checkbox("uncheck");
            getLocData("All");
            doSearch();
        },
        onUnchecked:function(event,val){
            $("#allTemplateNav").css("display","none");
            $("#navcategory").css("display","block");
            getLocData();
            doSearch();
        }
    });
    //点击tab
    $HUI.tabs("#navcategory",{
        onSelect: function(title,index){
            gl.currentCategoryId = navCategoryData[index].CategoryID;
            internalID = navCategoryData[index].InternalID;
            if(title =="手术相关")
            {
	            $('#personaTempDiv').css("display","none");
	        }
	        else
	        {
		        $('#personaTempDiv').css("display","block");
		    } 
            //根据诊断取病种关联模板,知情同意书没有病种下拉框
            if ((sysOption.openDiseaseTemp=="Y")&&(internalID != "EMR07")){
                document.getElementById("diseDesc").style.visibility="visible";
                document.getElementById("dise").style.visibility="visible";
                if(_flagInit){
                    initDisease();
                    _flagInit = false;
                }
            }else{
                document.getElementById("diseDesc").style.visibility="hidden";
                document.getElementById("dise").style.visibility="hidden";
            }
            if (navCategoryData[index].ItemURL != ""){
                var tab = $("#navcategory").tabs("getTab",index);
                var tbIframe = $("#"+tab[0].id+" iframe:first-child");
                if (tbIframe.attr("src") == ""){
                    tbIframe.attr("src",navCategoryData[index].ItemURL);
                }
                return;
            }
            getLocData();
            doSearch();
        }
    });
    initNavCategory();
    initTree("#listAlltemplate");
    if (sysOption.isCheckAllTemp == "Y"){
        $("#allTemp").checkbox("check");
    }
});
///整合Ajax请求入参
function ajaxDATA() {
    var data = {
        OutputType: arguments[0],
        Class: arguments[1],
        Method: arguments[2]
    };

    for (var i = 3; i < arguments.length; i++) {
        var num = i - 3;
        num = num>9?(90+num-9):num;
        data['p' + num] = arguments[i];
    }

    return data;
}
///获取病历文书目录数据
function getNavCategoryData(){
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"Stream",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"GetCategoryJsonByCategoryIDs",
            "p1":gl.categoryIds,
            "p2":gl.userId,
            "p3":gl.userLocId
        },
        success: function(d) {
            if (d == "") {
                return alert("未获取到病历文书目录数据，请检查当前页面是否已维护电子病历相关页面！");
            }
            navCategoryData = eval("["+d+"]");
        },
        error: function() { 
                alert("GetCategoryJsonByCategoryIDs error");
            }
        });
}
///病种
function initDisease(){
    //初始，选中患者本次就诊的病种
    var diseaseData = getPatDisease();
    if (diseaseData !=""){
        initDiseaseCom(diseaseData);
        $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);
    }else{
        var param = ajaxDATA("Stream","EMRservice.BL.BLUserTemplate","getDiseaseByDiagnos",sysOption.diagnosInfo,gl.userLocId);
        diseaseData = getDiseaseByDiagnos(param);
        initDiseaseCom(diseaseData);
        if(sysOption.diagnosInfo != ""){
            //诊断不为空  第一次时根据诊断关联的病种选中第一条
            if(diseaseData != ""){
                $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);
            }
        }
    }
}
///获取患者本次就诊的病种
function getPatDisease()
{
    var result = "";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLAdmPatType",
            "Method":"GetAdmPatType",
            "p1":gl.episodeId
        },
        success: function(d) {
            if (d != "{}"){
                result = eval("["+d+"]");
            }
        },
        error: function() { 
            alert("GetAdmPatType error");
        }
    }); 
    return result;
}
///根据诊断获取病种
function getDiseaseByDiagnos(param){
    var result = "";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: param,
        success: function(d) {
            result = eval(d); 
        },
        error: function() { 
            alert("getDiseaseByDiagnos error");
        }
    });
    return result;
}
///初始化病种下拉框
function initDiseaseCom(comData){ 
    $("#selDiseaseSpecies").combogrid({  
        panelWidth:278,
        panelHeight:200,
        idField:'Code',
        textField:'Name',
        data:comData,
        fitColumns: true,
        columns:[[  
            {field:'Code',title:'Code',width:130,sortable:true},  
            {field:'Name',title:'名称',width:130,sortable:true}  
         ]],
         keyHandler:{
            up: function() {
                //取得选中行
               var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRowIndex', selected);
                    //向上移动到第一行为止
                    if (index > 0) 
                    {
                        $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', index - 1);
                    }
                } 
                else 
                {
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', rows.length - 1);
                }
            },
            down: function() {
                //取得选中行
                var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');
                if (selected) 
                {
                    //取得选中行的rowIndex
                    var index = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRowIndex', selected);
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    //向下移动到最后一行为止
                    if (index < rows.length-1) 
                    {
                        $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', index + 1);
                    }
                }else{
                    var rows = $('#selDiseaseSpecies').combogrid('grid').datagrid('getRows');
                    $('#selDiseaseSpecies').combogrid('grid').datagrid('selectRow', 0);
                }
            },
            left: function () {
                return false;
            },
            right: function () {
                return false;
            },            
            enter: function () {
                //按enter键 
                //文本框的内容为选中行的的字段内容
                var selected = $('#selDiseaseSpecies').combogrid('grid').datagrid('getSelected');  
                if (selected) 
                { 
                    $('#selDiseaseSpecies').combogrid("options").value = selected.Name;
                }
                //选中后让下拉表格消失
                $('#selDiseaseSpecies').combogrid('hidePanel');
                $("#selDiseaseSpecies").focus();
            }, 
            query: function(q) {
                if(q==""){
                    $("#selDiseaseSpecies").combogrid('clear');   
                }
                var selLocId = $('#selLocId').combobox('getValue');
                selLocId = selLocId == "ALL"?"":selLocId;
                //动态搜索
                var param = ajaxDATA("Stream","EMRservice.BL.BLUserTemplate","getDiseaseByDiagnos","",selLocId,q);
                var diseaseData = getDiseaseByDiagnos(param);
                $("#selDiseaseSpecies").combogrid({data:diseaseData});
                $('#selDiseaseSpecies').combogrid("setValue", q);
            }
        },
        onSelect:function (rowIndex,rowData){
            if (_flagInit){
                return;
            }
            doSearch();
            //选中后，存储患者类型
            saveAdmPatType(rowData.Code);
        },
        onShowPanel:function(){
                var selLocId = $('#selLocId').combobox('getValue');
                selLocId = selLocId == "ALL"?"":selLocId;
            if(disSelectedLocId!=selLocId){
                disSelectedLocId = selLocId
                var param = ajaxDATA("Stream","EMRservice.BL.BLUserTemplate","getDiseaseByDiagnos","",selLocId,"");
                var diseaseData = getDiseaseByDiagnos(param);
                $("#selDiseaseSpecies").combogrid({data:diseaseData});
            }
        },
        onLoadSuccess:function(data){
        }
    });
}
///存储患者类型
function saveAdmPatType(diseaseCode)
{
    var result = "0";
    jQuery.ajax({
        type: "get",
        dataType: "json",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLAdmPatType",
            "Method":"SaveAdmPatType",
            "p1":gl.episodeId,
            "p2":diseaseCode,
            "p3":gl.userId
        },
        success: function(d) {
            result = d;
        },
        error: function() { 
            alert("SaveAdmPatType error");
        }
    }); 
    return result;
}
///获取科室下拉框数据
function getLocData(flag){
    var param = "";
    //知情告知
    if (internalID == "EMR07"){
        param = ajaxDATA("Stream","EMRservice.BL.BLEMRTemplateGroupLoc","GetAgreeRecordCTLocs",gl.currentCategoryId);
    }else{
        var currentCategoryId = flag == "All"?gl.categoryIds:gl.currentCategoryId;
        param = ajaxDATA("Stream","EMRservice.BL.BLUserTemplateCTLoc","GetUserTemplateCTLocs",currentCategoryId,"",gl.episodeId,gl.userId,gl.userLocId);
    }
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: param,
        success: function(d) {
            var data = "[]";
            if ((d != "")&(d != "[]")){
                if (internalID == "EMR07"){
                    $("#selLocId").combobox({value:"ALL"});
                }
                data = eval(d);
                $.each(data,function(idx,val){
                    //若有当前科室的科室模板则默认值为登录科室
                    if (val.RowID == gl.userLocId){
                        val.selected = true;
                        return false;
                    }
                });
            }else{
                $("#selLocId").combobox({value:""});
            }
            $("#selLocId").combobox({data:data});
        },
        error: function() { 
            alert("GetLocData error");
        }
    });
}
///初始化病历文书目录
function initNavCategory(){
    if (navCategoryData.length == 0){
        return;
    }
    for (i=0;i<navCategoryData.length;i++){
        var content = "<table id='listtemplate" + navCategoryData[i].CategoryID + "'></table>";
        if (navCategoryData[i].ItemURL != ""){
            var src = navCategoryData[i].ItemURL+'?EpisodeID='+gl.episodeId+'&CategoryID='+navCategoryData[i].CategoryID+'&Sequence='+navCategoryData[i].Sequence+'&Type=Template&ViewType='+navCategoryData[i].DisplayType;
            navCategoryData[i].ItemURL = src;
            content = content = "<iframe id='fram" + navCategoryData[i].CategoryID + "' frameborder='0' src='"+src+"' style='width:100%; height:100%;scrolling:no;margin:0px;'></iframe>";
        }
        addTab(navCategoryData[i].CategoryID,emrTrans(navCategoryData[i].ItemTitle),content,false)
    }
    $("#navcategory").tabs("select",0);
}
///增加tab标签
function addTab(tabId,tabTitle,content,selected)
{
    if($("#navcategory").tabs("exists",tabTitle)){
        $("#navcategory").tabs("select",tabTitle);
    }else{  
        $("#navcategory").tabs("add",{
            id: tabId,
            title: tabTitle,
            content: content,
            selected: selected
        });
    }
}
///查询模板
function doSearch(){
    var checkedFlag = $("#allTemp").checkbox("getValue");
    if (!checkedFlag){
        var flag = checkCategoryIdInLocId();
        if (flag != 1) {
            return;
        }
    }
    var selLocId = $('#selLocId').combobox('getValue');
    var searchText = $("#search").val().toUpperCase();
    var selDiseaseSpecies = "";
    if ((sysOption.openDiseaseTemp=="Y")&&(internalID != "EMR07")){
        var selected = $("#selDiseaseSpecies").combogrid("grid").datagrid("getSelected");
        if(selected){
            selDiseaseSpecies = selected.Code;
        }   
    }
    var param = "";
    var personalFlag = false;
    if ($("#personal").is(':checked'))
    {
	    param = ajaxDATA("Stream","EMRservice.BL.PersonalTemplate","GetCategoryDataForList",gl.userId,gl.currentCategoryId,gl.userLocId,gl.episodeId,searchText);
    	personalFlag = true;
    }else
    {
		if (checkedFlag){
	        param = ajaxDATA("Stream","EMRservice.BL.BLClientCategory","SelectAllCategoryJson",gl.categoryIds,gl.episodeId,gl.userId,"List","","",gl.userLocId,"",selLocId,searchText,selDiseaseSpecies);
	    }else{
	        param = ajaxDATA("Stream","EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryIDNew",gl.currentCategoryId,gl.episodeId,gl.userId,"List","","",gl.userLocId,"",selLocId,searchText,selDiseaseSpecies);
	    }
	}
	searchSelect(param,checkedFlag,personalFlag);}
///检查当前gl.currentCategoryId是否对应当前科室病历文书下的目录
function checkCategoryIdInLocId()
{
    var result="";
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLClientCategory",
            "Method":"CheckCategoryIdInLocId",
            "p1":gl.episodeId,
            "p2":gl.userLocId,
            "p3":gl.currentCategoryId,
            "p4":gl.groupId
        },
        success: function(d) {
            result = d;
        },
        error: function() { 
            alert("CheckCategoryIdInLocId error");
        }
    });
    return result;
}
///查询卡片
function searchSelect(param,checkedFlag,personalFlag)
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: param,
        success: function(d) {
            var data = eval("["+d+"]");
            if(personalFlag) data = eval("["+d+"]")[0];
            if (checkedFlag){
                $("#listAlltemplate").treegrid("loadData",data);
            }else{
                var tab = $("#navcategory").tabs("getSelected");
                var index = $("#navcategory").tabs("getTabIndex",tab);
                if(index == -1){
                    index = 0;
                }
                var initFlag = navCategoryData[index].initFlag || false;
                if (!initFlag){
                    initTree("#listtemplate"+gl.currentCategoryId);
                    navCategoryData[index].initFlag = true;
                }
                $("#listtemplate"+gl.currentCategoryId).treegrid("loadData",data);
            }
        },
        error: function() { 
            alert("searchSelect error");
        }
    }); 
}
///模板目录树
function initTree(tempListId)
{
    $(tempListId).treegrid({
        fitColumns:true, 
        headerCls:"panel-header-gray",
        loadMsg:'数据装载中......',
        autoRowHeight:true,
        nowrap:true,
        singleSelect:true,
        border:false,
        fit:true,
        idField:"id",
        treeField:"DocIDText",
        columns:[[
            {field:"id",title:"typeID",hidden:true},
            {field:"operate",title:"操作",width:22,formatter:operateContent},
            //2020-6-19 by yejian 名称显示修改docidtext
            {field:"text",title:"名称",width:300,sortable:true,hidden:true},
            {field:"DocIDText",title:"名称",width:300,sortable:true,formatter:show},
            {field:"emrDocId",title:"emrDocId",hidden:true},
            {field:"documentType",hidden:true},{field:"chartItemType",hidden:true},
            {field:"categoryId",hidden:true},{field:"templateId",hidden:true},
            {field:"isLeadframe",hidden:true},{field:"isMutex",hidden:true},
            {field:"JaneSpell",hidden:true},{field:"FullFight",hidden:true}
        ]],
        onDblClickRow:function(rowIndex, rowData){
            if (rowData.type == "flod")
            {
                if (rowData.state == "closed")
                {
                    $(tempListId).treegrid("expand", rowData.id);
                }
                else
                {
                    $(tempListId).treegrid("collapse", rowData.id);
                }
            }else if ((rowData.attributes != undefined)&&(rowData.attributes.type != undefined)&&(rowData.attributes.type != "node")){
                if (rowData.state == "closed")
                {
                    $(tempListId).treegrid("expand", rowData.id);
                }
                else
                {
                    $(tempListId).treegrid("collapse", rowData.id);
                }
            }
            else
            {
                CreateClick(rowData.id);
            }
        },
		onLoadSuccess:function(data){
			$.parser.parse($('.bottom'));
		}
    });
}
///操作描述
function operateContent(val,row,index)
{
    var span = "";
    if (row.type == "flod") return;
    //span = '<img title="新建" align="center" src="../scripts/emr/image/icon/add.png" style="margin-left:5px;" onclick="CreateClick('+"'"+row.id+"'"+')"/>'
    span = " <div class=\"bottom\"><a id=\"buttom"+row.id+"\" href=\"#\" title=\"新建\" class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-add',plain:true\" style=\"margin-left:5px\" onclick=\"CreateClick("+"'"+row.id+"'"+")\"></a></div>"
    if(row.quotation == "1")
    {
        //span += '<img title="引用" align="center" src="../scripts/emr/image/icon/quoate.png" style="margin-left:10px;"  onclick="QuoteClick('+"'"+row.id+"'"+')"/>'; 
    	span +=  " <div class=\"bottom\"><a href=\"#\" title=\"引用\" class=\"hisui-linkbutton\" data-options=\"iconCls:'icon-double-quotes',plain:true\" style=\"margin-left:10px\" onclick=\"QuoteClick("+"'"+row.id+"'"+")\"></a></div>"
    }
    return span;    
}
///鼠标放在上面显示全名
function show(val,row){
    if (val){        
        return '<span title="' + val + '">' + val + '</span>';    
    } else {        
        return val;    
    }
}
///取当前模板树ID
function getTreeID(){
    var tempListId = "#listtemplate"+gl.currentCategoryId;
    var checkedFlag = $("#allTemp").checkbox("getValue");
    if (checkedFlag){
        tempListId = "#listAlltemplate";
    }
    return tempListId;
}

///////////////////////////////模板操作///////////////////////////////
///从模板新建
function CreateClick(id)
{
    var tempListId = getTreeID();
    $(tempListId).treegrid("select",id);
    var row = $(tempListId).treegrid("getSelected");
    if (row)
    {
        var tabParam ={
            "id":"",
            "text":row.text,
            "pluginType":row.documentType,
            "chartItemType":row.chartItemType,
            "emrDocId":row.emrDocId,
            "templateId":row.templateId,
            "isLeadframe":row.isLeadframe,
            "isMutex":row.isMutex,
            "categoryId":row.categoryId,
            "actionType":"CREATE",
            "status":"NORMAL",
            "closable":true,
            "flag":"List"
        };
        if (row.attributes){
            if (((row.attributes.nodetype != undefined)&&(row.attributes.nodetype != "leaf"))||((row.attributes.type != undefined)&&(row.attributes.type != "node"))){
                return;
            }
            tabParam.titleName = row.text;
            if (row.attributes.nodetype == "leaf"){
                tabParam.titleCode = row.attributes.TitleCode;
                tabParam.userTemplateCode = row.attributes.Code;
            }else{
                tabParam.actionType = "CREATEBYPERSONAL";
                tabParam.exampleId = row.id;
                tabParam.categoryId = gl.currentCategoryId;
                tabParam.chartItemType = row.attributes.chartItemType;
                tabParam.emrDocId = row.attributes.emrdocId;
                tabParam.pluginType = row.attributes.documentType;
                tabParam.templateId = row.attributes.templateId;
                tabParam.titleCode = row.attributes.titleCode;
                tabParam.isLeadframe = row.attributes.isLeadframe;
                tabParam.isMutex = row.attributes.isMutex;
            }
        }         
        if (!IsAllowOEPCreateConfig(tabParam.text, tabParam.emrDocId))
        {
            return;
        }
        if (row.attributes){
            if ((tabParam.titleCode != undefined)&&(tabParam.titleCode != "")){
                var content = "<iframe id='iframeModifyTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId+"&Action=modifyTitle"+"&TitleCode="+tabParam.titleCode+"' style='width:100%;height:100%;display:block;'></iframe>";
                createModalDialog("temptitleDialog","修改标题","510","445","iframeModifyTitle",content,modifyTempTitleCallBack,tabParam);
                return;
            }else{
                //自动记录病例操作日志
                CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
                operateRecord(tabParam);
            }
        }else{
             //获取多文档加载未创建时默认加载的titleCode
            /*var defaultLoadId = getDefaultLoadId(tabParam.emrDocId,tabParam.templateId);
            var hasTemplate = GetHasUserTemplate(tabParam.emrDocId);
            if ((hasTemplate)&&(defaultLoadId == ""))
            {
                var iframeContent = "<iframe id='iframeTempTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId + "' style='width:100%;height:100%;display:block;'></iframe>";
                createModalDialog("temptitleDialog","模板选择","525","660","iframeTempTitle",iframeContent,modifyTempTitleCallBack,tabParam);
                return;
            }*/
            operateRecord(tabParam);
            //自动记录病例操作日志
            CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
        }
        //自动记录病例操作日志
        //CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
        //operateRecord(tabParam);
    }
}
//根据系统参数OEPCreateConfig配置判断是否可创建
function IsAllowOEPCreateConfig(text, docId) {
    var result = true;
    if ("" != sysOption.OEPCreateConfig)
    {
        var isAllowCreate = sysOption.OEPCreateConfig.split("|");
        if (-1 != $.inArray(docId, isAllowCreate[0].split("^")))
        {
            jQuery.ajax({
                type: "GET",
                dataType: "text",
                url: "../EMRservice.Ajax.common.cls",
                async: false,
                cache: false,
                data: {
                    "OutputType":"String",
                    "Class":"EMRservice.BL.opInterface",
                    "Method":"IsAllowCreateByConfig",
                    "p1": gl.patientId,
                    "p2": gl.userLocId,
                    "p3": isAllowCreate[1]
                },
                success: function (ret) {
                    if (ret === "0") {
                        $.messager.alert(emrTrans("提示"), emrTrans("不能创建")+text+emrTrans("，请先创建初诊病历！"), "info");
                        result = false;
                    }
                },
                error: function (ret) {
                    alert("IsAllowCreateByConfig error:" + ret);
                }
            });
        }
    }
    return result;
}
//获取多文档加载未创建时默认加载的titleCode
function getDefaultLoadId(emrDocId,templateID)
{
    var defaultLoadId = "";
    jQuery.ajax({
            type : "GET", 
            dataType : "text",
            url : "../EMRservice.Ajax.common.cls",
            async : false,
            data : {
                    "OutputType":"String",
                    "Class":"EMRservice.BL.BLTitleConfig",
                    "Method":"GetDefaultLoadTitleCode",
                    "p1":emrDocId,
                    "p2":gl.userLocId,
                    "p3":gl.episodeId,
                    "p4":templateID
                },
            success : function(d) {
                    defaultLoadId = d;
            },
            error : function(d) { alert("GetDefaultLoadTitleCode error");}
        });
    return defaultLoadId;
}
//是否有用户模板
function GetHasUserTemplate(docId)
{
    var result = false;
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLUserTemplate",
            "Method":"HasUserTemplate",
            "p1":gl.userLocId,
            "p2":docId
        },
        success: function(d) {
            if (d == "1") result = true;
        },
        error : function(d) { 
            alert("GetHasUserTemplate error");
        }
    });
    return result;
}
///取用户模板标题修改信息
function modifyTempTitleCallBack(returnValue,tabParam)
{
    if (returnValue !== undefined)
    {
        if (returnValue.titleCode != "") 
        {
            tabParam.titleCode = returnValue.titleCode;
            tabParam.actionType = "CREATEBYTITLE";
            tabParam.titleName = returnValue.titleName;
            tabParam.dateTime = returnValue.dateTime;
            tabParam.titlePrefix = returnValue.titlePrefix;
            tabParam.doctorID = returnValue.doctorID;
        }
        if ((returnValue.eventID != "")&&(returnValue.eventType != ""))
        {
            var argJson = {event:{"EventID":returnValue.eventID,"EventType":returnValue.eventType}};
            tabParam.args = argJson;
        }
        if ((tabParam.exampleId != undefined)&&(tabParam.exampleId != "")) 
        {
            tabParam.actionType = "CREATEBYPERSONAL";
            //tabParam.exampleId = returnValue.exampleId;
        }
        if (!tabParam.userTemplateCode){
            tabParam.userTemplateCode = returnValue.code;
        }
    }
    //自动记录病例操作日志
    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
    operateRecord(tabParam);
}
///从既往病历新建
function QuoteClick(id)
{
    var tempListId = getTreeID();
    $(tempListId).treegrid("select",id);
    var row = $(tempListId).treegrid("getSelected");
    if (row)
    {
        var docId = row.emrDocId;
        var url = "emr.ip.quotation.csp?EpisodeID="+gl.episodeId+"&PatientID="+gl.patientId+"&DocID="+docId+"&MWToken="+getMWToken()
        var iframeContent = "<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src=" +url+" style='width:100%; height:100%; display:block;overflow:hidden'></iframe>"
        createModalDialog("quotationDialog","病历引用",window.screen.width-400,window.screen.height-380,"iframeQuotation",iframeContent,quotationListCallBack,row,true,false);
    }
}
///病历引用
function quotationListCallBack(returnValue,row)
{
    if ((!returnValue)||(returnValue == "")) return;
    var tabParam ={
        "id":"",
        "text":row.text,
        "pluginType":row.documentType,
        "chartItemType":row.chartItemType,
        "emrDocId":row.emrDocId,
        "templateId":row.templateId,
        "isLeadframe":row.isLeadframe,
        "isMutex":row.isMutex,
        "categoryId":row.categoryId,
        "actionType":"QUOTATION",
        "status":"NORMAL",
        "closable":true,
        "pInstanceId":returnValue,
        "flag":"List"
    };
    //自动记录病例操作日志
  	operateRecord(tabParam);
}

//获取个人模板
function loadPersonTemplate(searchText)
{
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: true,
		data: {
			"OutputType":"Stream",
			"Class":"EMRservice.BL.PersonalTemplate",
			"Method":"GetCategoryDataForList",
			"p1":gl.userId,
			"p2":gl.currentCategoryId,
			"p3":gl.userLocId,
            "p4":gl.episodeId,
            "p5":searchText
		},
		success: function(d) {
			if (d == "") return;
			var data = eval("["+d+"]")[0];
			$('#listtemplate'+gl.currentCategoryId).treegrid('loadData',data);
		},
		error : function(d) { 
			alert("getPersonalTreeData error");
		}
	});
}


function operateRecord(tempParam)
{
    var categoryId = tempParam.categoryId;
    var tabParam = base64encode(utf16to8(escape(JSON.stringify(tempParam))));
    var tabName = "CategoryID="+categoryId; 
    parent.recordParam = tempParam;
    parent.setting.categoryId = categoryId;
    parent.docID = tempParam.emrDocId
 
 	window.returnValue = "Create";
 	_flagCreate = true;
    windowClose();
}
function windowClose()
{
	parent.closeDialog("dialogCreateRecord");
}

function dialogBeforeClose()
{
	if (_flagCreate == false)
	{
		window.returnValue = "closeWithOutCreate";
	}
}