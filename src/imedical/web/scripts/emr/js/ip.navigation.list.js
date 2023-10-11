var TempData = "";
var GridData = "";
//病种查询过的科室
var disSelectedLocId = "";
//模板跨科检索
var searchAcrossDepartDocID = getSearchAcrossDepartDocID();
//病种数量
var _diseaseCount=0;
//病种初始化标志
var _flagInit = true;
//知情告知标识 "EMR07"
var internalID = "";
var showType = "all";
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
    $("#doSearch").click(function() {
        doSearch();
    });
    TemplateList();
    ListInstance();
    init();
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
            "p1":gl.categoryId,
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
function getLocData(){
    var param = "";
    //知情告知
    if (internalID == "EMR07"){
        param = ajaxDATA("Stream","EMRservice.BL.BLEMRTemplateGroupLoc","GetAgreeRecordCTLocs",gl.categoryId);
    }else{
        param = ajaxDATA("Stream","EMRservice.BL.BLUserTemplateCTLoc","GetUserTemplateCTLocs",gl.categoryId,"",gl.episodeId,gl.userId,gl.userLocId);
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
//表格视图显示
function init()
{
	showType = "all";
	if(parent.setDisplay){
		parent.setDisplay("allBtn","oftenBtn");
	}
    var flag = checkCategoryIdInLocId(gl.episodeId,gl.userLocId,gl.categoryId,gl.groupId);
    if (flag == 1) {
        getLocData();
        doSearch();
    }
    getListRecord("EMRservice.BL.BLClientCategory","GetInstanceJsonByCategoryID",gl.categoryId,gl.episodeId,false,"List",gl.sequence);
    GridData = $("#gridshow").datagrid("getData").rows;
    var hidePersonalCategoryID = getHidePersonalCategoryID();
    if ($.inArray(gl.categoryId,hidePersonalCategoryID)>-1)
	{
		$('#personDiv').hide();
	}
	else
	{
		$('#personDiv').show();
	}
}

//获取知情告知和病案首页的categoryID
function getHidePersonalCategoryID()
{
	var categoryID = new Array();
	jQuery.ajax({
		type: "get",
		dataType: "text",
		url: "../EMRservice.Ajax.common.cls",
		async: false,
		data: {
			"OutputType":"String",
			"Class":"EMRservice.BL.BLSysOption",
			"Method":"GetOptionValueByName",
			"p1":"SearchAcrossDepartment"
		},
		success: function(d) {
			if (d != "") 
			{
				var strXml = convertToXml(d);
			    $(strXml).find("item").each(function(){
				    var code = $(this).find("code").text();
				    categoryID.push(code);
			    });	
			    if (medRecordCategoryID != "")
			    {
				    categoryID.push(medRecordCategoryID);
			    }	
			}
		},
		error : function(d) { 
			alert("getHidePersonalCategoryID error");
		}
	});
	
    return categoryID;
}

function filterOften() {
  showType = "part";
  if ($.inArray(gl.categoryId, searchAcrossDepartDocID) > -1&&internalID!==""&&navCategoryData[0].isGetAgree==="Y") {
	var selLocId = $('#selLocId').combobox('getValue') || "";
    //知情同意书并开启全院权限
    var param = ajaxDATA("Stream","EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryIDNew",gl.categoryId,gl.episodeId,gl.userId,"List","","",gl.userLocId,gl.docID,selLocId,"","","collect");
    getListTemplate(param);
  } else {
    //显示过滤的模板
    var AtempData = $("#listtemplate").treegrid("getData");
    getFilterRes(filterTemplate(AtempData));
  }
}
function getFilterRes(collectData){
	$("#listtemplate").treegrid("loadData", collectData);
	}
function filterTemplate(AtempData){
	var collectData = [];
	var len=AtempData.length,i=0;
	for(;i<len;i++){
		var item = AtempData[i];
		if(item.children&&item.children.length!==0){
			var resArry = [],flag=0;
			var tempArry = item.children;
			var childlen = tempArry.length,j=0;		
			for(;j<childlen;j++){
				if(tempArry[j].isCollect==="1"){
					resArry.push(tempArry[j]);
					flag=1;
					}
				}
			item.children = resArry;
			if(flag||item.isCollect==="1"){
				collectData.push(item);
				}
			}else if(item.isCollect==="1"){
				collectData.push(item);
			}
		}
	return collectData;
}
function getAllCollectTemplate(className, methodName, async) {
  jQuery.ajax({
    type: "get",
    dataType: "text",
    url: "../EMRservice.Ajax.common.cls",
    async: async,
    data: {
      OutputType: "Stream",
      Class: className,
      Method: methodName,
      p1: gl.categoryId,
      p2: gl.episodeId,
      p3: gl.userId,
      p4: "List",
      p5: "",
      p6: "",
      p7: ""
    },
    success: function (d) {
      var data = eval("[" + d + "]");
      //var treeData = filterData(data);
      $("#listtemplate").treegrid("loadData", data);
    },
    error: function (d) {
      alert("getAllCollectTemplate error");
    }
  });
}
///查询模板
function doSearch(){
	if(parent.setDisplay){
		parent.setDisplay("allBtn","oftenBtn");
	}
    var selLocId = $('#selLocId').combobox('getValue') || "";
    var searchText = $("#search").val().toUpperCase();
    var selDiseaseSpecies = "";
    if((sysOption.openDiseaseTemp=="Y")&&(internalID != "EMR07")){
        var selected = $("#selDiseaseSpecies").combogrid("grid").datagrid("getSelected");
        if(selected){
            selDiseaseSpecies = selected.Code;
        }   
    }
    if ($("#personal").is(':checked'))
    {
	    loadPersonTemplate(searchText);
    }
    else
    {
    	var param = ajaxDATA("Stream","EMRservice.BL.BLClientCategory","GetTempCateJsonByCategoryIDNew",gl.categoryId,gl.episodeId,gl.userId,"List","","",gl.userLocId,gl.docID,selLocId,searchText,selDiseaseSpecies);
    	getListTemplate(param);
    }
    
    TempData = $("#listtemplate").treegrid("getData");
}
///查询卡片
function getListTemplate(param)
{
    jQuery.ajax({
        type: "get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: false,
        data: param,
        success: function(d) {
            var data = eval("["+d+"]");
            $('#listtemplate').treegrid('loadData',data);
        },
        error: function() { 
            alert("GetTempCateJsonByCategoryIDNew error");
        }
    }); 
}
//加载模板表格视图列表
function TemplateList()
{
    $('#listtemplate').treegrid({
        iconCls:'icon-paper',
        fitColumns:true, 
        title:"新建模板列表",
        headerCls:'panel-header-gray',
        loadMsg:'数据装载中......',
        autoRowHeight:true,
        nowrap:true,
        singleSelect:true,
        fit:true,
        idField:'id',
        treeField:'DocIDText',
        toolbar:'#tempSearch',
        columns:[[
            {field:'id',title:'typeID',hidden:true},
	    	{field:'operate',title:'操作',width:65,formatter:operateContent},
            //2020-6-19 by yejian 名称显示修改docidtext
            {field:'text',title:'名称',width:300,sortable:true,hidden:true},
            {field:'DocIDText',title:'名称',width:300,sortable:true,formatter:show},
            {field:"emrDocId",title:"emrDocId",hidden:true},
            {field:'documentType',hidden:true},{field:'chartItemType',hidden:true},
            {field:'categoryId',hidden:true},{field:'templateId',hidden:true},
            {field:'isLeadframe',hidden:true},{field:'isMutex',hidden:true},
            {field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true}
        ]],
        onBeforeCollapse:function(){
            $("#layout").layout("panel","north").panel("resize",{height:50});
            $("#layout").layout("resize");
        },
        onBeforeExpand:function(){
            $("#layout").layout("panel","north").panel("resize",{height:180});
            $("#layout").layout("resize");          
        },
        onDblClickRow:function(rowIndex, rowData){
            if (rowData.type == "flod")
            {
                if (rowData.state == "closed")
                {
                    $('#listtemplate').treegrid('expand', rowData.id);
                }
                else
                {
                    $('#listtemplate').treegrid('collapse', rowData.id);
                }
            }
            else
            {
                CreateClick(rowData.id);
            }
        },
        onLoadSuccess:function(row, data){
            //输血链接列表视图下文件夹默认展开
            if (gl.docID !== "") $('#listtemplate').treegrid('expandAll');
        }
    });
}

//鼠标放在上面显示全名
function show(val,row){
    if (val){
        return '<span title="' + val + '">' + val + '</span>';
    } else {
        return val;
    }
}

//搜索知情同意书新建模板列表
function searchListTemplate(className,methodName,searchValue,parentID,episodeID,async,displaytype)
{
    jQuery.ajax({
        type: "Get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: async,
        data: {
            "OutputType":"Stream",
            "Class":className,
            "Method":methodName,
            "p1":searchValue,
            "p2":parentID,
            "p3":episodeID,
            "p4":userID,
            "p5":displaytype
        },
        success: function(d) {
            var data = eval("["+d+"]");
            for(var i=0;i<data.length;i++)
            {
                if((data[i].children != undefined)&&(data[i].children !=""))
                {
                    data[i].state = "open";
                }
            }
            $('#listtemplate').treegrid('loadData',data);
        },
        error : function(d) { 
            alert("searchListTemplate error");
        }
    });
}
function operateContent(val,row,index)
{
	var collect="none",removeCollect="none";
	if(row.isCollect==="1"){
		collect = "none";
		removeCollect="";
		}else{
		collect = "";
		removeCollect="none";
	}
	var removeImg = '<img align="center" class="removeCollectImg'+row.id+'"  alt="移除收藏"  title="'+emrTrans("移除收藏")+'" style="cursor:pointer; width: 16px;margin-left:10px; display:'+removeCollect+';" src="../scripts/emr/image/icon/favorite.png" onclick="removeClick('+"'"+row.id+"'"+')"/>';
	var collect ='<img align="center" class="addCollectImg'+row.id+'" alt="添加收藏"  title="'+emrTrans("添加收藏")+'" style="cursor:pointer; width: 16px;margin-left:10px;display:'+collect+';" src="../scripts/emr/image/icon/favorite_add.png" onclick="addClick('+"'"+row.id+"'"+')"/>';	    
    var span = '';
    if (row.type == "flod") return;
    var showbtnname = "新建通用模板";
    if (row.type == "UserTem"){
        showbtnname = "新建科室模板";
    }
    if ((row.type == "PersonalCate")||((row.attributes != undefined)&&(row.attributes.nodeType=="personal"))){
        showbtnname = "新建个人模板";
    }
    span = '<span class="listOperate" onclick="CreateClick('+"'"+row.id+"'"+')"><img title="'+showbtnname+'" align="center" src="../scripts/emr/image/icon/add.png" style="margin-left:5px;"/></span>'
	//因列表模式下直接展示，不需要提供展开科室模板的流程。
	//span += '<span class="listOperate" onclick="SelectTemplateClick('+"'"+row.id+"'"+')"><img title="选择模板新建" align="center" src="../scripts/emr/image/icon/listmore.png" style="margin-left:10px;" /></span>'; 
	if(row.quotation == "1")
	{
		span += '<span class="listOperate" onclick="QuoteClick('+"'"+row.id+"'"+')"><img title="引用" align="center" src="../scripts/emr/image/icon/quoate.png" style="margin-left:10px;" /></span>'; 
		
	}
	return span+removeImg+collect;		
}
function addClick(id){
  　window.event.cancelBubble = true;
  	var row = $('#listtemplate').treegrid('find',id);
  	var idStr = id;
  	if(row.type==="TempCate"){
	  	idStr = id.replace("TempCate-","");
	}
	var userID = gl.userId;
	if (row){	
	$.ajax({
		url:"../EMRservice.Ajax.CollectTemplate.cls?Action=AddCollect",
		type:"POST",
		data:{
			userID:userID,
	  		Id: idStr
		},
		success:function(result){
			if(+result===-1){
				$.messager.alert("提示","添加失败","info");
			}else{
				$(".addCollectImg"+id).css("display","none");
				//显示移除收藏图标
				$(".removeCollectImg"+id).css("display","");
				//更新节点信息这个方法会同时更新$("#listtemplate").treegrid("getData")
				row.isCollect = "1";
				$('#listtemplate').treegrid('update',{
					id: id,
					row:row
				});
				}
			},
		error:function(error){
			$.messager.alert("错误","添加失败","error");
			}
		});
	}
}
//移除收藏
function removeClick(id){
	window.event.cancelBubble = true;
	var row = $('#listtemplate').treegrid('find',id);
	var text = "确定移除收藏"+row.text+"?";
	$.messager.confirm("删除",text, function (r) {
		if (r) {
			removeCollect(id,row);
		} 
	});
}
function removeCollect(id,row){
	var userID = gl.userId;
	var parentId= row["_parentId"];
	var idStr = id;
	if(row.type==="TempCate"){
		idStr = id.replace("TempCate-","");
		}
	if (row){	
		$.ajax({
		url:"../EMRservice.Ajax.CollectTemplate.cls?Action=removeCollect",
		type:"POST",
		data:{
			userID:userID,
	  		Id: idStr
		},
		success:function(result){
			if(+result===-1||result===""){
				$.messager.alert("提示","移除失败","info");
			}else{
				//更新节点信息
				row.isCollect = "0";
				$('#listtemplate').treegrid('update',{
					id: id,
					row:row
				});
				//显示收藏图标
				$(".addCollectImg"+id).css("display","");
				//显示移除收藏图标
				$(".removeCollectImg"+id).css("display","none");
				if(showType==="part"){
					var $tr = $(".addCollectImg"+id).closest("tr");
					var $parentTr = $tr.parents("tr").prev("tr");
					var $tbody = $tr.parent("tbody");
					$tr.remove();
					var brotherTr = $tbody.find("tr").length;
					if(parentId!==undefined&&brotherTr===0){
						$parentTr.css("display","none");
					}
					}
				}
			},
		error:function(error){
			$.messager.alert("错误","移除失败","error");
			}
		});
		}
	
	}
//从模板新建
function CreateClick(id)
{
    $('#listtemplate').treegrid('select',id);
    var row = $('#listtemplate').treegrid('getSelected');
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
            if ((row.attributes.nodetype != "leaf")&&(row.attributes.nodeType != "personal")) {
                return;
            }
	        tabParam.titleName = row.text;
            if (row.attributes.nodetype == "leaf")
            {
	            tabParam.titleCode = row.attributes.TitleCode;
	            tabParam.userTemplateCode = row.attributes.Code; 
            }
            else
            {
	            tabParam.actionType = "CREATEBYPERSONAL";
				tabParam.exampleId = row.id;
				tabParam.categoryId = gl.categoryId;
				tabParam.chartItemType = row.attributes.chartItemType;
				tabParam.emrDocId = row.attributes.emrdocId;
				tabParam.pluginType = row.attributes.documentType;
				tabParam.templateId = row.attributes.templateId;
				tabParam.titleCode = row.attributes.titleCode;
				tabParam.isLeadframe = row.attributes.isLeadframe;
				tabParam.isMutex = row.attributes.isMutex;
            }
            if ((tabParam.titleCode != undefined)&&(tabParam.titleCode != "")){
                var content = "<iframe id='iframeModifyTitle' scrolling='auto' frameborder='0' src='emr.ip.navigation.template.csp?DocID="+tabParam.emrDocId+"&LocID="+gl.userLocId+"&EpisodeID="+gl.episodeId+"&Action=modifyTitle"+"&TitleCode="+tabParam.titleCode+"' style='width:100%;height:100%; display:block;'></iframe>";
                createModalDialog("temptitleDialog","修改标题","525","490","iframeModifyTitle",content,SelectTempTitle,tabParam);
                return;
            }else{
                operateRecord(tabParam);
                //自动记录病例操作日志
                CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
            }
        }
		else
		{
			operateRecord(tabParam);
            //自动记录病例操作日志
            CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.Create");
		}
    }
}

//从模板新建
function SelectTemplateClick(id)
{
    $('#listtemplate').treegrid('select',id);
    var row = $('#listtemplate').treegrid('getSelected');
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
        
        getParamByUserTemplate(tabParam);

    }
}

//从既往病历新建
function QuoteClick(id)
{
    $('#listtemplate').treegrid('select',id);
    var row = $('#listtemplate').treegrid('getSelected');
    if (row)
    {
        var docId = row.emrDocId;
        //showQuotationDialog("病历引用","<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src='emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId+"' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>","quotationListCallBack()");
        var iframeContent = "<iframe id='iframeQuotation' scrolling='auto' frameborder='0' src='emr.ip.quotation.csp?EpisodeID="+episodeID+"&PatientID="+patientID+"&DocID="+docId+"' style='width:100%; height:100%; display:block;overflow:hidden'></iframe>"
        parent.createModalDialog("quotationDialog","病历引用",window.screen.width-300,window.screen.height-300,"iframeQuotation",iframeContent,quotationListCallBack,row,true,false)
    }
}

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
    operateRecord(tabParam);
    
    //自动记录病例操作日志
    CreateDocumentLog(tabParam,"EMR.Nav.RecordNav.CreateInOld");
}



//加载表格病历实例
function getListRecord(className,methodName,parentID,episodeID,async,displaytype,sequence)
{
    jQuery.ajax({
        type: "Get",
        dataType: "text",
        url: "../EMRservice.Ajax.common.cls",
        async: async,
        data: {
            "OutputType":"Stream",
            "Class":className,
            "Method":methodName,
            "p1":parentID,
            "p2":episodeID,
            "p3":displaytype,
            "p4":sequence,
            "p5":gl.docID
        },
        success: function(d)
        {
            var data = eval("["+d+"]");
            $('#gridshow').datagrid('loadData',data);
        },
        error: function(d){alert("getListRecord error");}
    });
}
//表格视图列表
function ListInstance()
{
    $('#gridshow').datagrid({
        iconCls:'icon-paper',
        headerCls:'panel-header-gray',
        loadMsg:'数据装载中......',
        autoRowHeight:true,
        singleSelect:true,
        idField:'id',
        sortOrder:'desc',
        remoteSort:false,
        nowrap:true,
        fit:true,
        toolbar:[],
        columns:[[
            {field:'id',title:'id',hidden:true},
            {field:'status',title:'医生签名状态',width:160,formatter:StatusOperate,sortable:true},
			{field:'patientsign',title:'患者待签',width:100,formatter: PatientStatusOperate,sortable:true,hidden:isPatCAOn!="1"},
            {field:'printstatus',title:'打印状态',width:80,sortable:true,formatter:printedStatus},
            {field:'text',title:'名称',width:150,sortable:true},
            {field:'templateName',title:'模板名称',width:150,sortable:true},
            {field:'createdate',title:'创建日期',width:100,sortable:true},
            {field:'createtime',title:'创建时间',width:90,sortable:true},
            {field:'happendate',title:'发生日期',width:100,sortable:true,hidden:true},
            {field:'happentime',title:'发生时间',width:80,sortable:true,hidden:true},
            {field:'creator',title:'创建人',width:100},
            {field:'operateDate',title:'最后修改日期',width:100},
            {field:'operateTime',title:'最后修改时间',width:100},			
            {field:'operator',title:'最后修改人',width:100},
            {field:'summary',title:'备注',width:292,formatter: function(value,row,index){return '<span style="display:block;width:100%;min-height:34px;line-height:34px;" onclick="updateMemo('+index+')" title='+value+'>'+value+'</span>'}},
            {field:'documentType',hidden:true},
            {field:'chartItemType',hidden:true},
			{field:'pdfDocType',hidden:true},
            {field:'emrDocId',hidden:true},{field:'emrNum',hidden:true},
            {field:'templateId',hidden:true},{field:'isLeadframe',hidden:true},
            {field:'isMutex',hidden:true},{field:'categoryId',hidden:true},
            {field:'JaneSpell',hidden:true},{field:'FullFight',hidden:true}
        ]],
        //点击表格病历打开
        onDblClickRow:function(index,row)
        {
            var tabParam ={
                "id":row.id,
                "text":row.text,
                "pluginType":row.documentType,
                "chartItemType":row.chartItemType,
                "characteristic":row.characteristic,
                "emrDocId":row.emrDocId,
                "templateId":row.templateId,
                "templateName":row.templateName,
                "isLeadframe":row.isLeadframe,
                "isMutex":row.isMutex,
                "categoryId":row.categoryId,
				"pdfDocType":row.pdfDocType,
                "actionType":"LOAD",
                "status":"NORMAL",
                "closable":true,
                "flag":"List"
            };
            parent.parent.changeCurrentTitle(tabParam.text,tabParam.categoryId);
            operateRecord(tabParam);
            
            //自动记录病例操作日志
            openDocumentLog(tabParam,"EMR.Nav.RecordNav.Open");
        }
    });
}
//签名状态设置
function StatusOperate(val,row,index)
{
    if(row.doctorwait == "1")
    {
        var span = '<a style="color:#FB9A42;">'+emrTrans("待签");  
    }else{
        var span = '<a>'+row.status;
    }
	if (row.doctorIsSignCA == "1")
	{
		span = span + '<img src="../scripts/emr/image/icon/docCAgrid.svg" width="16" height="16" style="margin-left:10px" />'
	}
    span = span + '</a>';  
    return span;   
}

//设置病历打印状态
//打印后未修改病历有打印标识,若修改会导致病历签名失效,此时打印也算失效 --- 北京妇产
function printedStatus(val,row,index)
{
    if (val != ""){
        return val;
    }else if(row.printDesc != ""){
        return emrTrans(row.printDesc);
    }else{
        return emrTrans("未打印");
    }
}

function searchSelect(value)
{
    var categoryId = parent.parent.$("#sortName").attr("categoryId")
    if(!(/^[\u4e00-\u9fa5]+$/i).test(value)){
         value = value.toUpperCase();
    }
    if (($.inArray(gl.categoryId,searchAcrossDepartDocID)>-1)&&(value !== ""))
    {
        searchListTemplate("EMRservice.BL.BLClientCategory","GetInformConsentTempCateJson",value,gl.categoryId,gl.episodeId,false,"List");
    }else{
        var tmpTemplateData = findTemplate(TempData,value);
        $('#listtemplate').treegrid('loadData',tmpTemplateData);
    }
    
    var tmpRecordData = findRecord(GridData,value);
    $('#gridshow').datagrid('loadData',tmpRecordData);
    
}

///查询模板节点
function findTemplate(data,value)
{
    var result = new Array();
    for (var i = 0; i < data.length; i++) 
    { 
        if (data[i].children)
        {
            var child = findTemplate(data[i].children,value)
            if ((child != "")&&(child.length >0))
            {
                var tmp = JSON.parse(JSON.stringify(data[i]));
                tmp.children = [];
                tmp.children = child;
                result.push(tmp);
            }
        }
        else
        {
            if (data[i].text.indexOf(value)!=-1) result.push(data[i]);
        }
    }
    return result;
}

///查询实例
function findRecord(data,value)
{
    var result = new Array();
    for (var i = 0; i < data.length; i++) 
    {
        if (data[i].text.indexOf(value)!=-1) result.push(data[i]);
    }
    return result;
}

function PatientStatusOperate(val,row,index)
{
    var span = '<a>'+emrTrans(row.patSignStatus)
	if (row.patSignStatus.indexOf("已签") != -1)
	{
		span = span + '<img src="../scripts/emr/image/icon/patCAgrid.svg" width="16" height="16" style="margin-left:10px" />'
	}
	span = span + '</a>';
    return span;
}
///编辑备注///////////////////////////////////////////////////////////////////////////////////////////////////////////
var instanceId = "";
var recordIndex = "";
var oldTime = 0; 
var clickFunction = "";
$(function(){
    //编辑备注
    
    $('#memo').css("display","block");
    $('#memo').window('close');
    //保存备注信息
    $('#memoSure').click(function(){
        var memoText = $('#memoText').val();
        if (memoText.length > 1000)
        {
            alert("备注内容超出1000字数限制");
        }else{
            save(instanceId,memoText);
        }
    });

    //取消或关闭编辑备注
    $("#memoCancel").click(function(){
        $('#memo').window('close');
    });
});

//保存备注信息
function save(id,memoText){
    $.ajax({
        type: "post",
        url: "../EMRservice.Ajax.common.cls",
        data: {
            "OutputType":"String",
            "Class":"EMRservice.BL.BLInstanceData",
            "Method":"SetDocumentMemo",
            "p1":id,
            "p2":stringTJson(memoText)
        },
        error: function (XMLHttpRequest, textStatus, errorThrown) {
            alert(textStatus);
        },
        success: function (data) {
            if (data == "1")
            {
                $('#memo').window('close');
                $('#gridshow').datagrid('updateRow',{
                    index: recordIndex,
                    row: {
                        summary:memoText
                    }
                });
                
            }
            else
            {
                alert("备注修改失败!");
            }
        }
    });
}

function updateMemo(index){
    var time = new Date();
    if(time-oldTime<500){
        clearTimeout(clickFunction);
        return
    }
    oldTime = time;
     clickFunction = setTimeout(function(){
        recordIndex = index;
        var rows = $('#gridshow').datagrid('getRows');//获得所有行
        var row = rows[index];
        instanceId =row.id;
        var value = row.summary;
        //var memo = $(this).next().children().html();
        $('#memo').window('open');
        $('#memoText').val("");
        $('#memoText').val(value);
    },500)
};

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
			"p2":gl.categoryId,
			"p3":gl.userLocId,
            "p4":gl.episodeId,
            "p5":searchText
		},
		success: function(d) {
			if (d == "") return;
			var data = eval("["+d+"]")[0];
			$('#listtemplate').treegrid('loadData',data);
			TempData = data;
		},
		error : function(d) { 
			alert("getPersonalTreeData error");
		}
	});
}
