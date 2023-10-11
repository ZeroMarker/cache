/**
 * 医生分配类型  dhcpe.distributetype.js
 * @Author   wangguoying
 * @DateTime 2021-02-01
 */

var _SetpWidth=160;


/**
 * [节点代码对照]
 * @type {Array}
 */
var _FlowRelate=null;


function initSetp(){
	$.cm({
	    wantreturnval: 1,
	    ClassName: 'web.DHCPE.WorkDistribution',
	    MethodName: 'GetFlowSetpJSON'
	}, function(data) {
		_FlowRelate=data._FlowRelate;
		$("#WorkFlow").hstep({
		    showNumber:false,
		    stepWidth:_SetpWidth,
		    currentInd:_FlowRelate.length,
		    onSelect:select_flow,
		    titlePostion:"bottom",
		    items:data.items
		});
		setLayout();
		setTimeout(setActiveFLow,0);
	});
}



function setActiveFLow(){
	var activeFlow=tkMakeServerCall("web.DHCPE.WorkDistribution","GetActiveType");
    var inds = getActiveInds(activeFlow);
    $(".hstep-container-steps").find("li").each(function(){
         var ind = $(this).attr("ind");
         ind = parseInt(ind);
         if(ind > 1 && ind < _FlowRelate.length){
            if (inds.indexOf(ind)>=0){
                $("#Switch_"+ind).switchbox("setValue",true);
                $(this).css("color","rgb(38 190 106)");
            }else{
                $(this).css("color","#ccc");
            }
         }
         
    });
} 

/**
 * [业务节点选中事件]
 * @param    {[String]}    ind  [ind]
 * @param    {[Object]}    item [业务节点]
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function select_flow(ind,item){
    $(".hstep-container-steps").find("li").each(function(){
         var curInd = $(this).attr("ind");
         curInd=parseInt(curInd);
         if(curInd > 1 && curInd < _FlowRelate.length ){
            if (curInd == ind){
                 $(this).find(".cnode").addClass("pe-active").removeClass("cnode");
            }else{
                $(this).find(".pe-active").addClass("cnode").removeClass("pe-active");
            }
         }
    });
    

    var obj = getObjByInd(ind);
    $("#NodeCode").val(obj.code);
    $("#NodeInd").val(ind);

    if(ind==1 || ind==_FlowRelate.length){
        $("#DataDiv").fadeOut();
    }else{
        $("#DataDiv").fadeIn();
        $("#CSPPanel").panel("setTitle","【"+obj.desc+"】---链接CSP");
        initLinkDatagrid(obj.code);
        $("#CSPPanel").panel("resize");
        $("#DocPanel").panel("setTitle","【"+obj.desc+"】---医生集合");
        initDocTree(obj.code);
        $("#DocPanel").panel("resize");
    }  
}

/**
 * [根据ind 查询 ]
 * @param    {[String]}    ind [ind]
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function getObjByInd(ind){
    var obj =null;
    _FlowRelate.forEach( function(element, index){
        if(element.ind == ind) obj = element;
    });
    return obj;
}


/**
 * [获取激活的步骤节点]
 * @param    {[String]}    codes [激活的步骤代码]
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function getActiveInds(codes){
    var inds=[];
    if(codes == "")  return inds;
    var codeArr = codes.split("^");
    _FlowRelate.forEach( function(element, index) {
       if(codeArr.indexOf(element.code)>=0){
            inds.push(element.ind);
       }
    });
    return inds;
}


/**
 * [开启按钮切换事件]
 * @param    {[Object]}    event [事件]
 * @param    {[Object]}    obj   [当前对象]
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function switch_change(event,obj){
    var active="N";
    if (obj.value){
        active = "Y";
    }
    var ind =$(event.target.parentElement).attr("ind");
    var flowObj = getObjByInd(ind);
    if (flowObj == null){
        $.messager.aler("提示","未检索到业务代码","info");
        return false;
    }
    var ret = tkMakeServerCall("web.DHCPE.WorkDistribution","UpdateTypeByCode",flowObj.code,active);
    if(ret != ""){
        $.messager.alert("提示","切换状态失败："+ret,"error");
        return false;
    }
    $.messager.popover({msg: '切换成功',type:'success',timeout: 1000});
    if(obj.value){
        event.target.parentElement.style.color="green";
    }else{
        event.target.parentElement.style.color="#ccc";
    }
    if(active == "Y"){  //禁用到启用时无法触发节点选择事件
        select_flow(ind,"");
    }
   
}


/**
 * [设置医生集合]
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function initDocTree(code) {
    $.cm({
        wantreturnval: 1,
        ClassName: 'web.DHCPE.WorkDistribution',
        MethodName: 'GetDocJSONByType',
        Code: code,
		hospId:session['LOGON.HOSPID']
    }, function(data) {
        $('#DocTree').tree({
            onClick: function(node) {
            },
            onContextMenu: function(e, node) {
                e.preventDefault();
                //禁止浏览器的菜单打开
                set_rightMenu_disable(node);
                $(this).tree('select', node.target);
                $('#right-menu').menu('show', {
                    left: e.pageX,
                    top: e.pageY
                });
            },
            data: data
        });
    });
}

/**
 * [设置右键菜单是否可用]
 * @param    {[Object]}    node [点击的树节点]
 * @Author   wangguoying
 * @DateTime 2020-12-22
 */
function set_rightMenu_disable(node) {
    if (node.id == "ALL") { //根节点
        $("#right-menu").menu("enableItem", $('#appendNode')[0]);
        $("#right-menu").menu("disableItem", $('#delNode')[0]);
    } else if (node.id.indexOf("DOC_")==0){ //医生节点
        $("#right-menu").menu("enableItem", $('#appendNode')[0]);
        $("#right-menu").menu("enableItem", $('#delNode')[0]);
    }else{
         $("#right-menu").menu("disableItem", $('#appendNode')[0]);
        $("#right-menu").menu("enableItem", $('#delNode')[0]);
    }
}


/**
 * 新增子节点点击事件
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function addNode_click(){

    var node = $('#DocTree').tree('getSelected');
    if(node==null){
        $.messager.alert("提示","请先选择节点","info");
        return false;
    }
    var nodeType=node.id.split("_")[0];
    var id='';
    if(nodeType!="ALL") id=node.id.split("_")[1];
    switch (nodeType)
    {
        case "ALL":   //根节点        
            DocNodeClear(1);
            $("#Doctor").combogrid("enable");
            initDoctorCombogrid("");
            $("#AddDocWin").window("open");
            break;
        case "DOC":   //医生节点
            DocNodeClear(1);
            initDoctorCombogrid(node.text);
            $("#Doctor").combogrid("setValue",id);  
            $("#Doctor").combogrid("disable");       
            $("#AddDocWin").window("open");    
            break;
    }
}

/**
 * 删除节点按钮
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function delNode_click(){
    var node = $('#DocTree').tree('getSelected');
    if(node==null){
        $.messager.alert("提示","请先选择节点","info");
        return false;
    }
    var nodeType=node.id.split("_")[0];
    var id='';
    if(nodeType!="ALL") id=node.id.replace(nodeType+"_","");
    switch (nodeType)
    {
        case "ALL":   //根节点        
            break;
        case "DOC":   //医生节点
            delNodeHandler(id);
            break;
        case "GL":
            delNodeHandler(id.split("_").join("^"));
            break;
    }
}

/**
 * [删除医生]
 * @param    {[String]}    inString [医生ID^安全组ID^科室ID]
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function delNodeHandler(inString){
    var code = $("#NodeCode").val();
     if(code==""){
        $.messager.alert("提示","未选择流程节点","info");
        return false;
    }
    var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","DeleteDoctors",code,inString)
    if(ret!=""){
        $.messager.alert("错误",ret,"error");
        return false;
    }
    $.messager.popover({msg: '已删除',type:'success',timeout: 1000});
    initDocTree(code);
}

/**
 * [添加医生]
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function DocNodeSave(){
    var code=$("#NodeCode").val();
    if(code==""){
        $.messager.alert("提示","未选择流程节点","info");
        return false;
    }
    var doc=$("#Doctor").combogrid("getValue");
    var group=$("#Group").combogrid("getValue");
    var loc=$("#CTLoc").combogrid("getValue");
    if(doc==""){
        $.messager.alert("提示","医生不能为空","info");
        return false;
    }
    if(group==""){
        $.messager.alert("提示","安全组不能为空","info");
        return false;
    }
    if(loc==""){
        $.messager.alert("提示","科室不能为空","info");
        return false;
    }
    var valueList=doc+"^"+group+"^"+loc;
    var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","SaveDoctors",code,valueList);
    if(ret==""){
       $.messager.popover({msg: '切换成功',type:'success',timeout: 1000});
        $("#AddDocWin").window("close");
        initDocTree(code);
    }else{
        $.messager.alert("提示","添加失败："+ret,"error");
    }
}

/**
 * 重新绑定医生下拉列表
 * @Author   wangguoying
 * @DateTime 2019-05-13
 */
function initDoctorCombogrid(docDesc){
    $('#Doctor').combogrid({
        panelWidth: 320,
        idField: 'HIDDEN',
        textField: 'Description',
        method: 'get',
        url:$URL+'?ClassName=web.SSUser&QueryName=LookUp',
        onBeforeLoad:function(param){
            if(param.q!="" && param.q != undefined){
                docDesc=param.q;
            }
            param.desc =docDesc;
        },
        mode:'remote',
        delay:200,
        columns: [[ 
            {field:'HIDDEN',hidden:true},                                               
            {field:'Code',title:'代码',width:100},
            {field:'Description',title:'描述',width:150}
        ]],
        onLoadSuccess:function(){
        },
        onSelect:function(rowIndex,rowData){
        },
        fitColumns: true,
        displayMsg:'',
        pagination:true,
        pageSize:50
    });
    
}


/**
 * 添加医生权限框清屏按钮
 * @param    {[int]}    Flag [为1时，清掉saId,为0时不清]
 * @Author   wangguoying
 * @DateTime 2021-02-03
 */
function DocNodeClear(Flag)
{
	 var node = $('#DocTree').tree('getSelected');
    if(node!=null && node.id.split("_")[0]=="DOC"){
        
    }else{
    	$("#Doctor").combogrid("setValue","");
    }
    
    $("#Group").combogrid("setValue","");
    $("#CTLoc").combogrid("setValue","");
}


/**
 * [设置布局样式]
 * @Author   wangguoying
 * @DateTime 2021-02-02
 */
function setLayout(){
    //居中显示   最后一个节点占据一个流程宽度，需要从左侧留出，才能完全居中
    $(".hstep-container.hstep-lg").css("text-align","left");
    $(".hstep-container.hstep-lg").css("padding-left",_SetpWidth+"px");
    $(".hstep-progress").css("padding-left",_SetpWidth+"px");
    $(".hstep-container .hstep-progress").css("top","16px"); 

    $(".hstep-container-steps").find("li").each(function(){
        var ind = $(this).attr("ind");
        if(ind > 1  && ind < _FlowRelate.length){
             //$(this).append("<div id='switch_"+ind+"' class='hisui-switchbox' >3345</div>");
            $(this).append("<br><div id='Switch_"+ind+"' class='hisui-switchbox' style='margin-top:5px' data-options='checked:false,onText:\"启用\",offText:\"禁用\",size:\"mini\",animated:true,onClass:\"primary\",offClass:\"gray\",onSwitchChange:switch_change'></div>");
        }else{
            
        }
    });
    $.parser.parse("#WorkFlow");
    $(".hstep-container-steps").find("li").bind("contextmenu", function (e) {
        e.preventDefault();
        $(e.target).trigger("click");
        set_flowMenu_disable(e.target);
        $('#flow-menu').menu('show', {
            left: e.pageX,
            top: e.pageY
        });
     });  
}

/**
 * [设置业务类型的右键菜单是否可用]
 * @param    {[Object]}    node [点击的节点]
 * @Author   wangguoying
 * @DateTime 2021-02-07
 */
function set_flowMenu_disable(node) {
    var ind = $(node).attr("ind");
    if(ind==1){     //开始
        $("#flow-menu").menu("disableItem", $('#InsertPreNode')[0]);
        $("#flow-menu").menu("enableItem", $('#InsertAftNode')[0]);
        $("#flow-menu").menu("disableItem", $('#RemoveNode')[0]);
    }else if(ind == _FlowRelate.length){
        $("#flow-menu").menu("enableItem", $('#InsertPreNode')[0]);
        $("#flow-menu").menu("disableItem", $('#InsertAftNode')[0]);
        $("#flow-menu").menu("disableItem", $('#RemoveNode')[0]);
    }else{
        $("#flow-menu").menu("enableItem", $('#InsertPreNode')[0]);
        $("#flow-menu").menu("enableItem", $('#InsertAftNode')[0]);
        $("#flow-menu").menu("enableItem", $('#RemoveNode')[0]);
    }
}

/**
 * [新增业务类型]
 * @param {int} [flag] [1：前方插入 ； 2：后方插入]
 * @Author   wangguoying
 * @DateTime 2021-02-07
 */
function add_flow(flag){
    $("#H_Win_Flag").val(flag);
    flowType_clean();
    $("#AddFlowType").window("open");
}

/**
 * [保存类型]
 * @Author   wangguoying
 * @DateTime 2021-02-07
 */
function flowType_save()
{
    var flowCode = $("#NodeCode").val();
    var newCode=$("#Win_Code").val();
    var newDesc=$("#Win_Desc").val();
    var flag=$("#H_Win_Flag").val();
     if(flowCode == ""){
        $.messager.alert("提示","未定位到流程节点","info");
        return false;
    }
     if(newCode == ""){
        $.messager.alert("提示","代码不能为空","info");
        return false;
    }
     if(flowCode == ""){
        $.messager.alert("提示","描述不能为空","info");
        return false;
    }
    var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","InsertFlowType",flowCode,flag,newCode+"^"+newDesc);
    if(ret!=""){
        $.messager.alert("提示",ret,"error");
        return false;
    }
    $.messager.alert("提示","插入成功","success",function(){
        window.location.reload()
    });
}

function flowType_clean()
{
    $("#Win_Code").val("");
    $("#Win_Desc").val("");
}

/**
 * [删除业务类型]
 * @Author   wangguoying
 * @DateTime 2021-02-07
 */
function delete_flow(){
    var flowCode = $("#NodeCode").val();
    if(flowCode == ""){
        $.messager.alert("提示","未定位到流程节点","info");
        return false;
    }
    var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","DeleteFlowType",flowCode);
    if(ret!=""){
        $.messager.alert("提示",ret,"error");
        return false;
    }
    $.messager.alert("提示","删除成功","success",function(){
        window.location.reload()
    });
}

/**
 * [加载链接CSP]
 * @Author   wangguoying
 * @DateTime 2021-02-07
 */
function initLinkDatagrid(code){
    $HUI.datagrid("#LinkList",{
        bodyCls:'panel-body-gray',
        singleSelect:true,
        url:$URL,
        queryParams:{
            ClassName: "web.DHCPE.WorkDistribution",
            QueryName: "QueryWorkLinkUrl",
            Code: code  
        },
        onSelect:function(rowIndex,rowData){
        },
        onDblClickRow:function(index,row){
                                                            
        },  
        idField:'TID',
        columns:[[
            {field:'TID',hidden:true},
            {field:'TSort',width:40,title:'顺序'},
            {field:'TTitle',width:60,title:'标题'},
            {field:'TUrl',width:200,title:'CSP',showTip:true}
        ]],
        toolbar: [{
                iconCls: 'icon-add',
                text:'新增',
                handler:function(){
                    linkUrl_clean();
                    $("#AddLinkUrl").window("open");
                }
            },{
                iconCls: 'icon-remove',
                text:'删除',
                handler:delete_linkurl
        }],
        fitColumns:true,
        pagination:true,
        pageSize:10,
        fit:true
    });
    $("#LinkList").datagrid("clearSelections");
}


function delete_linkurl(){
    var row = $("#LinkList").datagrid("getSelected");
    if(row == null){
         $.messager.alert("提示","请选择要删除的数据","info");
            return false;
    }
    var ret=tkMakeServerCall("User.DHCPEWorkLinkUrl","Delete",row.TID);
    if(ret.split("^")[0]!="0"){
        $.messager.alert("提示",ret.split("^")[1],"error");
        return false;
    }
    $.messager.alert("提示","删除成功","success",function(){
        $("#LinkList").datagrid("reload");
         $("#LinkList").datagrid("clearSelections");
    });
}

/**
 * [保存链接]
 * @Author   wangguoying
 * @DateTime 2021-02-07
 */
function linkUrl_save()
{
    var flowCode = $("#NodeCode").val();
    var title=$("#Win_Link_Title").val();
    var link=$("#Win_Link_CSP").val();
    var sort=$("#Win_Link_Sort").val();
     if(flowCode == ""){
        $.messager.alert("提示","未定位到流程节点","info");
        return false;
    }
     if(title == ""){
        $.messager.alert("提示","标题不能为空","info");
        return false;
    }
     if(link == ""){
        $.messager.alert("提示","链接不能为空","info");
        return false;
    }
    if(sort == ""){
        $.messager.alert("提示","顺序不能为空","info");
        return false;
    }
    var ret=tkMakeServerCall("web.DHCPE.WorkDistribution","InsertLinkUrl",flowCode,title+"^"+link+"^"+sort);
    if(ret!=""){
        $.messager.alert("提示",ret,"error");
        return false;
    }
    $("#AddLinkUrl").window("close");
    $.messager.popover({msg: '添加成功',type:'info',timeout: 2000,showType: 'show'});
    $("#LinkList").datagrid("reload");
}

function linkUrl_clean()
{
    $("#Win_Link_Title").val("");
    $("#Win_Link_CSP").val("");
    $("#Win_Link_Sort").val("");
}

function init(){
    initSetp();
}
$(init);