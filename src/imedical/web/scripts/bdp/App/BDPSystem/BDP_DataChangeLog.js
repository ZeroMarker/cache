/// 名称: 码表数据日志管理
/// 编写者: 基础数据平台组  sunfengchao  
/// 编写日期: 2013-1-29
///   增加查看日志时双击弹出窗口，动态生成列表功能
 //******************** 菜单树级联设置 ****************************//
function cascadeParent(){
    var pn = this.parentNode;
    if (!pn || !Ext.isBoolean(this.attributes.checked)) return;
    if (this.attributes.checked) { //级联选中
        pn.getUI().toggleCheck(true);
    }else {//级联未选中
        var b = true;
        Ext.each(pn.childNodes, function(n){
            if (n.getUI().isChecked()){
                return b = false;
            }
            return true;
        });
        if (b) pn.getUI().toggleCheck(false);
    }
    pn.cascadeParent();
}        
function cascadeChildren(){
    var ch = this.attributes.checked;
    if (!Ext.isBoolean(ch)) return;
    Ext.each(this.childNodes, function(n){
        n.getUI().toggleCheck(ch);
        n.cascadeChildren();
    });
}
Ext.apply(Ext.tree.TreeNode.prototype, {
    cascadeParent: cascadeParent,
    cascadeChildren: cascadeChildren
});
Ext.override(Ext.tree.TreeEventModel, {
    onCheckboxClick: Ext.tree.TreeEventModel.prototype.onCheckboxClick.createSequence(function(e, node){
        node.cascadeParent();
        node.cascadeChildren();
    })
});

document.write('<style> .x-grid3-cell-inner {white-space:normal; !important;} </style>'); //内容长的时候换行
var htmlurl = "../scripts/bdp/AppHelp/BDPSystem/BDP_DataChangeLog/BDP_DataChangeLog.htm";
document.write('<script type="text/javascript" src="../scripts/bdp/Framework/scripts/HtmlHelp.js"> </script>');
Ext.getUrlParam = function(param) { 
    var params = Ext.urlDecode(unescape(location.search.substring(1))); 
    return param ? params[param] : params; 
};
 /// 获取到表的 ID
var UserClass=Ext.getUrlParam('UserClass'); 
var datestr=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDefaultDate");
var DateArr=[];
DateArr=datestr.split("^");
var StartDate=DateArr[0]; 
var EndDate= DateArr[1]; //7天前的日期 
Ext.onReady(function() {
    Ext.QuickTips.init();
    var pagesize_main = Ext.BDP.FunLib.PageSize.Main;
    Ext.BLANK_IMAGE_URL = '../scripts_lib/ext3.2.1/resources/images/default/s.gif';
    //var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.querydatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLog&pClassQuery=GetList";
    var QUERY_ACTION_URL = "../csp/dhc.bdp.ext.jsondatatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLog&pClassMethod=GetList";
    var QUERY_METHOD_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLog&pClassMethod=GetList";
	var TREE_QUERY_ACTION_URL = "../csp/dhc.bdp.ext.datatrans.csp?pClassName=web.DHCBL.BDP.BDPDataChangeLog&pClassMethod=GetTreeJson";
   
    /*************************************grid数据存储 *****************************************/ 
    Ext.BDP.FunLib.TableName="BDP_DataChangeLog"
    var ds = new Ext.data.Store({
                proxy : new Ext.data.HttpProxy({
                            url :QUERY_ACTION_URL  
                        }), 
                reader : new Ext.data.JsonReader({
                            totalProperty : 'total',
                            root : 'rows',
                            successProperty : 'success'
                        }, [{
                                    name : 'ID',
                                    mapping : 'ID',
                                    type : 'string'
                                }, {
                                    name : 'IpAddress',
                                    mapping : 'IpAddress',
                                    type : 'string'
                                }, {
                                    name : 'TableName',
                                    mapping : 'TableName',
                                    type : 'string'
                                }, {
                                    name : 'ClassName',
                                    mapping : 'ClassName',
                                    type : 'string'
                                }, {
                                    name : 'ClassNameDesc',
                                    mapping : 'ClassNameDesc',
                                    type : 'string'
                                }, {
                                    name : 'ObjectReference',
                                    mapping : 'ObjectReference',
                                    type : 'string'
                                }, {
                                    name : 'ObjectDesc',
                                    mapping : 'ObjectDesc',
                                    type : 'string'
                                }, {
                                    name : 'UpdateUserDR',
                                    mapping : 'UpdateUserDR',
                                    type : 'string'
                                }, {
                                    name : 'UpdateUserName',
                                    mapping : 'UpdateUserName',
                                    type : 'string'
                                }, {
                                    name : 'UpdateDate',
                                    mapping : 'UpdateDate',
                                    type : 'string' 
                                }, {
                                    name : 'UpdateTime',
                                    mapping : 'UpdateTime',
                                    type : 'time'
                                }, {
                                    name : 'OperateType',
                                    mapping : 'OperateType',
                                    type : 'string'
                                } 
                        ])
            });
 
    /***************************************grid加载数据 ********************************/
    ds.load({
        params : {  
                    ClassN : '',
                    UserDR :'',
                    OBJDESC : '',
                    datefrom :'',
                    dateto:'',
                    MenuDataStr:'',
                    OperateType:'',
                    UserClass:UserClass,
                    start : 0,
                    limit : pagesize_main
                } 
        });
    /****************************************grid分页工具条******************************/
    var paging = new Ext.PagingToolbar({
                pageSize : pagesize_main,
                store : ds,
                displayInfo : true,
                displayMsg : '显示第 {0} 条到 {1} 条记录,一共 {2} 条',
                emptyMsg : "没有记录",
                plugins : [new Ext.BDP.FunLib.PagingToolbarResizer()],
                listeners : {
                    "change":function (t,p) {
                        pagesize_main=this.pageSize;
                    }
                }
            });
   
//**************************************************************//
    /******************************** 批量查询菜单面板************************************************************* */
    var menuTreeLoader = new Ext.tree.TreeLoader({
                nodeParameter: "ParentID",
                dataUrl: TREE_QUERY_ACTION_URL 
            });
    var menuPanel = new Ext.tree.TreePanel({
            region: 'center',
            id: 'menuConfigTreePanel',
            expanded:true,
            root: ssordroot=new Ext.tree.AsyncTreeNode({
                    id:"menuTreeRoot",
                    text:"菜单",
                    draggable:false,  //可拖拽的
                    expanded:true  //根节点自动展开
                }),
            loader: menuTreeLoader,
            autoScroll: true,
            containerScroll: true,
            rootVisible:true,
            tbar:['检索',
                new Ext.form.TextField({
                    id:'FindTreeText',
                    width:100,
                    emptyText:'请输入查找内容',
                    enableKeyEvents: true,
                    listeners:{
                        keyup:function(node, event) {
                            findByKeyWordFiler(node);
                        },
                        scope: this
                    }
                }), '-', {
                    text:'批量查询',
                    tooltip:'批量查询日志',
                    iconCls:'icon-search',
                    handler: function () {
                        str="";
                        var f  = function(node) {  
                            var flag = this.attributes.checked; 
							var menuc=Ext.getCmp('FindTreeText').getValue();
							var menutext= node.text; 
							if ((menuc!=="")&(menuc!=="undefined")){ 
								if (menutext.indexOf(menuc)>=0){ 
									if(flag==true) {
										if (str!="") str=str+",{";
										else str=str+"{";
										str=str+"ID:"+node.id+"}"
									}
								}
							}
							else{
								if(flag==true) {
										if (str!="") str=str+",{";
										else str=str+"{";
										str=str+"ID:"+node.id+"}"
									}
							}
                        }
                        Ext.getCmp("menuConfigTreePanel").getRootNode().cascade(f); //在所有childnode上做f 级联查找时会层层扩展开
                        if(str!="") str="["+str+"]"; 
                        grid.getStore().baseParams={
                                ClassN : Ext.getCmp("ClassName").getValue(),
                                UserDR : Ext.getCmp("UpdateUserDR").getValue(),
                                OBJDESC : Ext.getCmp("ObjectDesc").getValue(),
                                datefrom : Ext.getCmp("datefrom").getValue()===""?"":Ext.getCmp("datefrom").getValue().format(BDPDateFormat),
                                dateto : Ext.getCmp("dateto").getValue()===""?"":Ext.getCmp("dateto").getValue().format(BDPDateFormat),
                                dizzyDesc:Ext.getCmp('fuzzyserch').getValue(),
                                UserClass:UserClass,
                                MenuDataStr:str,
                                OperateTypeD:Ext.getCmp('OperateType').getValue()
                        };
                        Tree1Window.hide();
                        ds.load({
                            params : {
                                start : 0,
                                limit : pagesize_main
                            }
                        });
                    }
                }, '-', {
                    text:'清空',
                    tooltip:'清空查找内容并取消选中的菜单',
                    iconCls:'icon-refresh',
                    handler:function(){
                        clearFind();  //清除树过滤
                    }
                },'-',{
                    xtype:'panel',
                    baseCls:'x-plain',
                    height:25,
                    items:[{
                        id : 'radioGroup1',
                        xtype : 'radiogroup',
                        columns: [52, 52, 52],
                        items : [{
                            id : 'radio1',
                            boxLabel : "全部",
                            name : 'FilterCK',
                            inputValue : '0',
                            checked : true,
                            listeners : {
                                'check' : function(com, checked){
                                    if(checked){
                                        findByRadioCheck('all');
                                    }
                                },
                                scope : this
                            }
                        }, {
                            id : 'radio2',
                            boxLabel : "已选",
                            name : 'FilterCK',
                            inputValue : '1',
                            listeners : {
                                'check' : function(com, checked){
                                    if(checked){
                                        findByRadioCheck('checked');
                                    }
                                },
                                scope : this
                            }
                        }, {
                            id : 'radio3',
                            boxLabel : "未选",
                            name : 'FilterCK',
                            inputValue : '2',
                            listeners : {
                                'check' : function(com, checked){
                                    if(checked){
                                        findByRadioCheck('unchecked');
                                    }
                                },
                                scope : this
                            }
                        }]
                    }]
                }]
    });
    
    /** 获取菜单面板 */
    function getMeunPanel(){
        return menuPanel;
    };

//**************** 树检索功能 ****************************************//
    var findByRadioCheck = function(flag){
        if(flag=='all'){
            menuPanel.root.cascade(function(n) {
                if(n.id!='menuTreeRoot'){
                    n.ui.show();
                }
            });
        }
        if(flag=='checked'){
            menuPanel.root.cascade(function(n) {
                if(n.id!='menuTreeRoot'){
                    n.ui.show();
                    if(!n.attributes.checked){
                        n.ui.hide();
                    }
                }
            });
        }
        if(flag=='unchecked'){
            menuPanel.root.cascade(function(n) {
                if(n.id!='menuTreeRoot'){
                    n.ui.show();
                    var falg = 1;
                    if(n.attributes.checked&&n.isLeaf()){
                        n.ui.hide();
                    }
                    else if(n.attributes.checked&&!n.isLeaf()){
                        n.cascade(function(n) {
                            if(!n.attributes.checked&&n.isLeaf()){
                                falg = 0;
                                return;
                            }
                        });
                        if (falg == 1)
                        {
                            n.ui.hide();
                        }
                        
                    }
                }
            });
        }
        Ext.getCmp('FindTreeText').reset();  ///切换 全部、已选、未选时，清空搜索框
    }
    
    var timeOutId = null;
    var treeFilter = new Ext.tree.TreeFilter(menuPanel, {
        clearBlank : true,
        autoClear : true
    });

    // 保存上次隐藏的空节点
    var hiddenPkgs = [];
    var findByKeyWordFiler = function(node) {
        clearTimeout(timeOutId);// 清除timeOutId
        menuPanel.expandAll();// 展开树节点
        // 为了避免重复的访问后台，给服务器造成的压力，采用timeOutId进行控制，如果采用treeFilter也可以造成重复的keyup
        timeOutId = setTimeout(function() {
            // 获取输入框的值
            var text = node.getValue();
            // 根据输入制作一个正则表达式，'i'代表不区分大小写
            var re = new RegExp(Ext.escapeRe(text), 'i');
            // 先要显示上次隐藏掉的节点
            Ext.each(hiddenPkgs, function(n) {
                n.ui.show();
            });
            hiddenPkgs = [];
            if (text != "") {
                treeFilter.filterBy(function(n) {
                    // 只过滤叶子节点，这样省去枝干被过滤的时候，底下的叶子都无法显示
                    return !n.isLeaf() || re.test(n.text);
                });
                // 如果这个节点不是叶子，而且下面没有子节点，就应该隐藏掉
                menuPanel.root.cascade(function(n) {
                    if(n.id!='0'){
                        if(!n.isLeaf() &&judge(n,re)==false&& !re.test(n.text)){
                            hiddenPkgs.push(n);
                            n.ui.hide();
                        }
                    }
                });
            } else {
                ///2016-3-7  解决“勾选【已选】或【未选】前提下，检索框中输入内容查询，再删除内容并回车后，已选和未选条件失效，查询出了全部菜单”bug
                if (!(Ext.getCmp('radio1').getEl().dom.checked))
                {
                    
                    if (Ext.getCmp('radio2').getEl().dom.checked)
                    {
                        findByRadioCheck('checked');
                    }
                    if (Ext.getCmp('radio3').getEl().dom.checked)
                    {
                        findByRadioCheck('unchecked');
                    }
                }
                else
                {
                    treeFilter.clear();
                }
                return;
            }
        }, 500);
    }
    
    // 过滤不匹配的非叶子节点或者是叶子节点
    var judge =function(n,re){
        var str=false;
        n.cascade(function(n1){
            if(n1.isLeaf()){
                if(re.test(n1.text)){ str=true;return; }
            } else {
                if(re.test(n1.text)){ str=true;return; }
            }
        });
        return str;
    };
    // 清除树过滤
    var clearFind = function () {
        Ext.getCmp('FindTreeText').reset();
        var nodes = Ext.getCmp('menuConfigTreePanel').getChecked(); 
                if (nodes && nodes.length) { 
                for (var i = 0; i < nodes.length; i++) { 
                //设置UI状态为未选中状态 
                nodes[i].getUI().toggleCheck(false); 
                //设置节点属性为未选中状态 
                nodes[i].attributes.checked = false; 
            }
        }
        if (!(Ext.getCmp('radio1').getEl().dom.checked))
        {
            
            if (Ext.getCmp('radio2').getEl().dom.checked)
            {
                Ext.getCmp('radio2').setValue(false);
            }
            if (Ext.getCmp('radio3').getEl().dom.checked)
            {
                Ext.getCmp('radio3').setValue(false);
            }
            Ext.getCmp('radio1').setValue(true);
        }
        menuPanel.root.cascade(function(n) {
                    if(n.id!='0'){
                            n.ui.show();
                        }
                });
    }
 
    var str = "";
    var Tree1Window = new Ext.Window({
        title: '菜单批量查询',
        closable: true,      
        width: 600,
        height: 460,
        border: false,
        layout: 'border',
        modal : true,
        closeAction : 'hide',
        items: [menuPanel],
        buttonAlign:'center',
        buttons: [{
            text: '批量查询',
            handler: function () {
                str="";
                var f  = function(node) {
                    var flag = this.attributes.checked;
					var menuc=Ext.getCmp('FindTreeText').getValue();
					var menutext= node.text; 
					if ((menuc!=="")&(menuc!=="undefined")){ 
						if (menutext.indexOf(menuc)>=0){ 
							if(flag==true) {
								if (str!="") str=str+",{";
								else str=str+"{";
								str=str+"ID:"+node.id+"}"
							}
						}
					}
					else{
						if(flag==true) {
								if (str!="") str=str+",{";
								else str=str+"{";
								str=str+"ID:"+node.id+"}"
							}
					} 
                }
                Ext.getCmp("menuConfigTreePanel").getRootNode().cascade(f); //在所有childnode上做f 级联查找时会层层扩展开
                if(str!="") str="["+str+"]";
                grid.getStore().baseParams={
                        ClassN : Ext.getCmp("ClassName").getValue(),
                        UserDR : Ext.getCmp("UpdateUserDR").getValue(),
                        OBJDESC : Ext.getCmp("ObjectDesc").getValue(),
                        datefrom : Ext.getCmp("datefrom").getValue()===""?"":Ext.getCmp("datefrom").getValue().format(BDPDateFormat),
                        dateto : Ext.getCmp("dateto").getValue()===""?"":Ext.getCmp("dateto").getValue().format(BDPDateFormat),
                        dizzyDesc:Ext.getCmp('fuzzyserch').getValue(),
                        MenuDataStr:str,
                        UserClass:UserClass,
                        OperateTypeD:Ext.getCmp('OperateType').getValue()
                };
                Tree1Window.hide();
                ds.load({
                    params : {
                        start : 0,
                        limit : pagesize_main
                    }
                });
            }
        },{
            text: '取消',
            handler: function () { 
                Tree1Window.hide();
                
           }
        }],
        listeners:{
            'show':function(){
                clearFind();  //清除树过滤
            },
            'hide':function(){
                Ext.getCmp('FindTreeText').reset();
                var nodes = Ext.getCmp('menuConfigTreePanel').getChecked(); 
                if (nodes && nodes.length) { 
                for (var i = 0; i < nodes.length; i++) { 
                //设置UI状态为未选中状态 
                nodes[i].getUI().toggleCheck(false); 
                //设置节点属性为未选中状态 
                nodes[i].attributes.checked = false; 
                }
              }
            }
        }
    }); 
                
        var btnGroup = new Ext.Button({
                id : 'group_btn',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('group_btn'),
                iconCls : 'icon-AdmType',
                text : '菜单批量查询',
                handler :function(){
                    menuPanel.dataUrl=TREE_QUERY_ACTION_URL;
                    menuPanel.expandAll();
                    Tree1Window.show();
                }
            }); 
         
/******************************数据生命周期********************************************/
    var DataLiftBtn=new Ext.Button({
                id:'DataLiftBtn',
                disabled:Ext.BDP.FunLib.Component.DisableFlag('DataLiftBtn'),
                text:'数据生命周期' ,
                icon:Ext.BDP.FunLib.Path.URL_Icon +'datalife.png',
                handler:function(){ 
                    var gsm = grid.getSelectionModel(); 
                    var rows = gsm.getSelections(); 
                    if(rows.length>0){
                      if (rows.length==1){
                        var ObjectReference1= rows[0].get('ObjectReference');
                        var ClassName1=rows[0].get('ClassName');
                        var ObjectDesc1=rows[0].get('ObjectDesc');  // 对象描述
						var height=Ext.getBody().getViewSize().height-30 ;	
                        var Log_Win = new Ext.Window({
                                        title:'数据生命周期->'+ObjectDesc1,
                                        width :1120,
                                        height :height,
                                        layout : 'fit',
                                        plain : true, 
                                        modal : true,
                                        frame : true,
                                        constrain : true,
                                        closeAction : 'hide'  
                            });
							var url="dhc.bdp.bdp.timeline.csp?actiontype=timeline&ClassN="+ClassName1+"&OBJDESC="+ObjectReference1+"&ObjectDesc="+ObjectDesc1;
							if ('undefined'!==typeof websys_getMWToken)
							{
								url += "&MWToken="+websys_getMWToken() //增加token
							} 
							var url=encodeURI(url) 
                            Log_Win.html='<iframe id="timeline" src=" '+url+' " width="100%" height="100%"></iframe>';
                            Log_Win.show();
                        }
                        else
                        {
                            
                             Ext.Msg.show({
                                            title:'提示',
                                            minWidth:280,
                                            msg:'不能同时查看多行数据!',
                                            icon:Ext.Msg.WARNING,
                                            buttons:Ext.Msg.OK
                                        }); 
                        }
                     }
                else{
                        Ext.Msg.show({
                                            title:'提示',
                                            minWidth:280,
                                            msg:'请选择需要查看的数据行!',
                                            icon:Ext.Msg.WARNING,
                                            buttons:Ext.Msg.OK
                                        }); 
                    }
                }
            });
    
            
    var datadetailbtn=new Ext.Button({
            id:'LookUpDataDetail',
            disabled:Ext.BDP.FunLib.Component.DisableFlag('LookUpDataDetail'),
            text:'查看数据详情' ,
            iconCls : 'icon-DP',
            handler:function()
            {
                var gsm = grid.getSelectionModel(); 
                var rows = gsm.getSelections(); 
                if(rows.length>0)
                {
                  if (rows.length==1){
                    var ClassUserName=grid.selModel.getSelections()[0].get('ClassName');
                    var ClassUserNameDesc=grid.selModel.getSelections()[0].get('ClassNameDesc');
                    var Operation=grid.selModel.getSelections()[0].get('OperateType');
                    if(Operation=="U"){
                        Operation="修改操作"            
                    }
                    if(Operation=="A"){
                        Operation="添加操作"            
                    }
                    if(Operation=="D"){
                        Operation="删除操作"            
                    }
                    if (ClassUserName!="User.BDPPreferences") //((ClassUserName!="User.BDPTableList")&&)
                    { 
                       
						var height=Ext.getBody().getViewSize().height-30  ;  //Math.min(Ext.getBody().getViewSize().height-350,790);	
                        var Log_Win = new Ext.Window
                        ({
                                    title:ClassUserNameDesc+'->'+Operation,
                                    width :1100,
                                    height :height,
                                    layout : 'fit',
                                    plain : true, 
                                    modal : true,
                                    frame : true,
                                    // autoScroll : true,
                                    constrain : true,
                                    closeAction : 'hide'  
                            });
							var url="dhc.bdp.bdp.timeline.csp?actiontype=datadetail&id="+grid.selModel.getSelections()[0].get('ID');
							var url=encodeURI(url)
							if ('undefined'!==typeof websys_getMWToken)
							{
								url += "&MWToken="+websys_getMWToken() //增加token
							} 
                            Log_Win.html='<iframe id="timeline" src=" '+url+' " width="100%" height="100%"></iframe>';
                            Log_Win.show();
                        }
                        else
                        { 
                             try
                             {
                                var OldValueJson=""
                                var redata =""
                                var id=grid.selModel.getSelections()[0].get('ID');
                                var ShowOperate=grid.selModel.getSelections()[0].get('OperateType'); 
                                var UserClass=grid.selModel.getSelections()[0].get("ClassName");
                                var ClassNameDesc = grid.selModel.getSelections()[0].get('ClassNameDesc');
                                var showTitleName=ClassNameDesc 
                                var returnJson=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDataDetail",id);
                                var objectJson=eval('(' + returnJson + ')');
                                var newdata =objectJson.NewValue    
                                /// 再次调用后台json数据 
                                /// 正常情况下,NewValue 是非空的 
                                if (newdata!=""){
                                    var jsondata = eval('(' + newdata + ')');
                                    var newjson = "{";
                                    var oldjson2="{";
                                    var olddata= objectJson.OldValue            
                                     /// 原始数据存在  undefined 情况未处理？？捕获异常后抛出异常
                                    if (olddata!=""){ 
                                        //修改 :存在一种情况：操作是修改，但是没有OldValue,只有 NewValue
                                         var oldjson= eval('('+olddata+')')
                                         redata = [oldjson,jsondata]
                                    }
                                    else{
                                        ////olddata 为空
                                         redata = [jsondata]
                                    }
                                for(var x in jsondata)
                                {
                                    if (newjson!= "{")
                                    {
                                        newjson = newjson + ","
                                    }
                                    if (oldjson2!= "{")
                                    {
                                        oldjson2 = oldjson2 + ","
                                    }
                                    /// 获取属性
                                    var Property=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropDescByCode",UserClass,x);
                                    var PropertyData=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,jsondata[x]);
                                    PropertyData=PropertyData.substring(1,(PropertyData.length-1));
                                    var res = {fields:[{name:""+x+""}],columns:[{header:""+Property+"",dataIndex:""+x+"",width:130,sortable:true}]};  
                                    var columns = res.columns;
                                    var fields = res.fields;
                                    for (var i = 0; i < fields.length; i++) {
                                        Detailfd.push(fields[i].name);
                                        DetailCM.push(columns[i]);
                                    }
                                    if(olddata!=""){
                                        var PropertyDataY=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,oldjson[x]);
                                        PropertyDataY=PropertyDataY.substring(1,(PropertyDataY.length-1));
                                        // 原始数据与现数据进行比较
                                        if(PropertyDataY!=PropertyData)
                                        { ///bordeR-bottom:20px solid blue;   bordeR-bottom:20px solid red; 
                                            newjson = newjson + x+":"+'"<span style='+"'color:Red;bold:true;text-decoration:none'"+'>'+PropertyData +'</span>"' 
                                            oldjson2= oldjson2 + x+":"+'"<span style='+"'color:blue;bold:true; text-decoration:none'"+'>'+PropertyDataY +'</span>"' 
                                        }
                                        else
                                        {
                                            newjson = newjson + x+":"+'"'+PropertyData +'"' 
                                            oldjson2= oldjson2+ x+":"+'"'+PropertyDataY +'"'    
                                        }       
                                    }
                                    else{ /// 如果是 添加或者删除时，进行拼串
                                        newjson = newjson + x+":"+'"'+PropertyData +'"' 
                                    }
                                }
                            var newjson = newjson + "}";
                            var newjsondata = eval('(' + newjson + ')');
                            
                            var oldjson = oldjson2 + "}";
                            var oldjson = eval('(' + oldjson + ')');
                            win.show();
                        }
                        else{
                            ///  newdata为空的情况 : 直接进入 异常捕获了，没有进行下一步的执行。  
                            Ext.getCmp('UpdateDataText').setValue(OldValue);
                        }
                     
                        var ss=new Ext.data.JsonStore({ 
                            fields:Detailfd  
                        })  
                        DetailGrid.reconfigure(ss,new Ext.grid.ColumnModel(DetailCM));
                        if(olddata!=""){
                            ss.loadData([oldjson,newjsondata]);  
                            win.setIconClass("icon-update")
                            win.setTitle(showTitleName+"      "+"修改数据：第一行为原始数据，第二行为修正后数据")
                        }
                        else{
                            if(ShowOperate=="U"){
                                ss.loadData([newjsondata])
                                win.setTitle(showTitleName+"     "+"修改数据：修正后数据")
                                win.setIconClass("icon-update")
                            }
                            
                            if (ShowOperate=="A"){
                                ss.loadData([newjsondata])
                                win.setTitle(showTitleName+"     "+"添加数据")
                                win.setIconClass("icon-add")
                            }
                           if (ShowOperate=="D"){
                                ss.loadData([newjsondata])
                                win.setTitle(showTitleName+"      "+"删除数据")
                                win.setIconClass("icon-delete")
                            }  
                          } 
                     }
                        catch (e) 
                        {
                        /// 捕获异常后
                            if((newdata!="")&&(ShowOperate=="U")){
                                Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata);
                            }
                            if((olddata!="")&&(ShowOperate=="U")){
                                Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata); 
                            }
                            if((ShowOperate=="A")||(ShowOperate=="D")){
                                if(newdata!=""){
                                    Ext.getCmp('UpdateDataText').setValue(newdata); 
                            }
                        }
                          win2.show()  
                        }
                    }
                  }
                  else{
                     Ext.Msg.show({
                            title:'提示',
                            minWidth:280,
                            msg:'不能同时查看多行数据!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK
                        }); 
                  }
                }
                else{
                    Ext.Msg.show({
                            title:'提示',
                            minWidth:280,
                            msg:'请选择需要查看的数据行!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK
                        }); 
                    }
                }
            });
            
     
/** ****************************************搜索按钮 ********************************/
    var btnSearch = new Ext.Button({
                id : 'btnSearch',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnSearch'),
                iconCls : 'icon-search',
                text : '搜索',
                handler :search=function() {
					var datefrom=Ext.getCmp("datefrom").getValue();
					var dateto=Ext.getCmp("dateto").getValue();
					if (datefrom>dateto){
						Ext.Msg.show({
                            title:'提示',
                            minWidth:280,
                            msg:'开始日期不能大于结束日期!',
                            icon:Ext.Msg.WARNING,
                            buttons:Ext.Msg.OK
                        }); 
						return false;
					}
                    grid.getStore().baseParams={
                            ClassN : Ext.getCmp("ClassName").getValue(),
                            UserDR : Ext.getCmp("UpdateUserDR").getValue(),
                            OBJDESC : Ext.getCmp("ObjectDesc").getValue(),
                            datefrom : Ext.getCmp("datefrom").getValue()===""?"":Ext.getCmp("datefrom").getValue().format(BDPDateFormat),
                            dateto : Ext.getCmp("dateto").getValue()===""?"":Ext.getCmp("dateto").getValue().format(BDPDateFormat),
                            dizzyDesc:Ext.getCmp('fuzzyserch').getValue(),
                            MenuDataStr:str,
                            UserClass:UserClass,
                            OperateTypeD:Ext.getCmp('OperateType').getValue()
                    };
                    grid.getStore().load({
                        params : {
                                    start : 0,
                                    limit : pagesize_main
                                }
                        });
                    }
            });
    
    /** ************************************重置按钮 ********************************************/
    var btnRefresh = new Ext.Button({
                id : 'btnRefresh',
                disabled : Ext.BDP.FunLib.Component.DisableFlag('btnRefresh'),
                iconCls : 'icon-refresh',
                text : '重置',
                handler : refresh=function() { 
                    Ext.getCmp("ClassName").reset();
                    Ext.getCmp("ObjectDesc").reset();
                    Ext.getCmp("UpdateUserDR").reset();
                    //Ext.getCmp("datefrom").reset();
                    //Ext.getCmp("dateto").reset();
                    Ext.getCmp('fuzzyserch').reset();
                    Ext.getCmp('OperateType').reset();
                    Ext.getCmp("datefrom").setValue(StartDate);
                    Ext.getCmp("dateto").setValue(EndDate); 
                    str="";
                    grid.getStore().baseParams={
                    	UserClass:UserClass,
                    	datefrom : StartDate,
                        dateto : EndDate
                    };
                    grid.getStore().load({
                        params : {
                                    start : 0,
                                    limit : pagesize_main
                                }
                            });
                    }
            });
  
    /** **********************************搜索工具条 **************************************/
    var tbbutton = new Ext.Toolbar({
            enableOverflow : true,
            items : [  
                        '操作人ID/操作人', {
                            width :77,
                            xtype : 'textfield',
                            id : 'UpdateUserDR',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('UpdateUserDR'),
                            listeners: {
                                specialkey: function(f,e){
                                         if (e.getKey() == e.ENTER) {
                                             search();
                                         }
                                          if (e.getKey() == e.ESC) {
                                            refresh()
                                         }
                                }
                             } 
                        },'-',
                        '操作类型',{
                             width : 110,
                             xtype:'combo',
                             id:'OperateType',
                             store:new Ext.data.SimpleStore({
                             fields:['OperateType','value'],
                             data:[
                                  ['A','添加'],
                                  ['D','删除'],
                                  ['U','修改'] 
                                ]
                           }),
                           displayField:'value',
                           valueField:'OperateType',
                           mode:'local',
                           triggerAction:'all',
                           listeners:{
                            'select':search
                           }
                    },'-',btnGroup,'-',btnSearch, '-', btnRefresh ,'->',datadetailbtn,'-',DataLiftBtn,'-',helphtmlbtn
            ]
        });
    var tb = new Ext.Toolbar({
                id : 'tb',
                items : ['全文检索', {
                            fieldLabel : '全文检索',
                            xtype : 'textfield',
                            id : 'fuzzyserch',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('fuzzyserch'),
                            width : 110 
                }, '-','功能描述', {
                            width : 110,
                            xtype : 'textfield',
                            id : 'ClassName',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('ClassName') 
                        }, '-','对象ID/描述', {
                            width :135,
                            xtype : 'textfield',
                            id : 'ObjectDesc',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('ObjectDesc') 
                        } ,'-',
                        '操作日期', {
                            width : 100,
                            xtype : 'datefield',
                            id : 'datefrom',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('datefrom'),
                            format : BDPDateFormat,
                            enableKeyEvents : true,
                            listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
                        },
                        '到', {
                            width : 100,
                            xtype : 'datefield',
                            id : 'dateto',
                            disabled : Ext.BDP.FunLib.Component.DisableFlag('dateto'),
                            format : BDPDateFormat,
                            enableKeyEvents : true,
                            listeners : {'keyup' : function(field, e){Ext.BDP.FunLib.Component.GetCurrentDate(field,e);}}
                        } 
                ] ,
                listeners : {
                    render : function() {
                        tbbutton.render(grid.tbar);
                        Ext.getCmp("datefrom").setValue(StartDate);
                        Ext.getCmp("dateto").setValue(EndDate); 
                    }
                }
            });
    
     
    /** ***********************************创建grid ****************************************/
   var logsm = new Ext.grid.CheckboxSelectionModel({
        singleSelect : false,
        checkOnly : false,
        width : 20
    });
    var grid = new Ext.grid.GridPanel({
                id : 'grid',
                region : 'center',
                closable : true,
                trackMouseOver : true,
                // monitorResize : true,
                trackMouseOver : true,
                columnLines : true,
                store : ds,
                stripeRows : true,
                stateful : true,
                viewConfig : {
                    forceFit: true,  
                    scrollOffset: 0 , 
                    emptyText:"<span style='color:red;<font size=15>;font-weight:bold;'>对不起,没有检索到相关数据.</span>'",
                    autoFill:true,
                    enableRowBody: true  
                },
                //sm:new Ext.grid.RowSelectionModel({singleSelect:false}),
                sm:new Ext.grid.CheckboxSelectionModel(), 
                columns : [//new Ext.grid.CheckboxSelectionModel(),  
                        logsm, {
                            header : 'ID',
                            sortable : true,
                            dataIndex : 'ID',
                            width : 20,
                            hidden : true
                        },{
                            header : '功能描述',
                            sortable : true,
                            dataIndex : 'ClassNameDesc', 
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            width : 70
                        },{
                            header : '表名称',
                            hidden:true,
                            sortable : true,
                            dataIndex : 'TableName',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            width : 60
                        }, {
                            header : '类名称',
                            sortable : true,
                            hidden:true,
                            dataIndex : 'ClassName',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            width :60
                        },{
                            header : '对象ID',
                            sortable : true,
                            dataIndex : 'ObjectReference',
                            width : 30
                        },{
                            header : '对象描述',
                            sortable : true,
                            width:70,
                            dataIndex : 'ObjectDesc'
                        }, {
                            header : '操作人 ',
                            sortable : true,
                            dataIndex : 'UpdateUserName',
                            renderer: Ext.BDP.FunLib.Component.GirdTipShow,
                            width:55
                        }, {
                            header : '操作类型',
                            sortable : true,
                            dataIndex : 'OperateType',
                            width : 40,
                            renderer : function(v){
                                if(v=='U'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"update.gif''>"+"   修改";}
                                if(v=='D'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"delete.gif''>"+"   删除";}
                                if(v=='A'){return "<img src='"+Ext.BDP.FunLib.Path.URL_Icon +"add.gif''>"+"   添加";}
                            }
                        } , {
                            header : '操作人IP',
                            sortable : true,
                            dataIndex : 'IpAddress',
                            width : 60
                        },  {
                            header : '操作人ID',
                            sortable : true,
                            hidden:true,
                            width:35,
                            dataIndex : 'UpdateUserDR'
                        }, {
                            header : '操作日期',
                            sortable : true,
                            dataIndex : 'UpdateDate',
                            width:65
                        }, {
                            header : '操作时间',
                            sortable : true,
                            dataIndex : 'UpdateTime',
                            width:65
                        }],
                title : '基础数据日志管理',
                monitorResize: true,
                doLayout: function() {
                    this.setSize(Ext.get(this.getEl().dom.parentNode).getSize(true));
                    Ext.grid.GridPanel.prototype.doLayout.call(this);
               },
                bbar : paging,
                tbar : tb,
                stateId : 'grid'
            });
 
 /*******************************动态生成列表格******************************************/
    var DetailCM=[] 
    var Detailfd = [];
    var DetailsDs=new Ext.data.JsonStore({
        fields:Detailfd
  });
 
 var DetailGrid=new Ext.grid.GridPanel({
       columns:DetailCM,
       store:DetailsDs,
       width:1000,
       height:400,
       autoScroll:true
    });
 
    var win = new Ext.Window({
        width : 1000,
        layout : 'fit',
        plain : true,
        modal : true,
        frame : true,
        collapsible : true,
        constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        buttonAlign : 'center',
        closeAction : 'hide',
        items :[DetailGrid],
        viewConfig : {
                    forceFit: true, // 注意不要用autoFill:true,那样设置的话当GridPanel的大小变化(比如你resize了它)时不会自动调整column的宽度
                    scrollOffset: 0 ,//不加这个的话,会在grid的最右边有个空白,留作滚动条的位置
                    autoFill:true,
                    enableRowBody: true  
                },
        listeners : {
                "show" : function() {
                                 
                },
                "hide" : function(){
                          DetailCM = [] 
                          Detailfd = [];  
                          win.hide()
                    }
                }    
            });
            
////无法解析json时的弹出窗口
var win2 = new Ext.Window({
        title : '修正的数据',
        width : 600,
        layout : 'fit',
        plain : true, 
        modal : true,
        frame : true,
        autoScroll : true,
        collapsible : true,
        constrain : true,
        hideCollapseTool : true,
        titleCollapse : true,
        buttonAlign : 'center',
        closeAction : 'hide',
        items : [new Ext.form.TextArea({
                id : 'UpdateDataText',
                readOnly : true,
                width : 600,
                height : 300
        })]
    });
    
/*********************日志的原始数据与修正数据进行比对，颜色显示**********************************************/
    grid.on("rowdblclick", function(grid, rowIndex, e){
        var gsm = grid.getSelectionModel(); 
        var rows = gsm.getSelections(); 
        var Operation=grid.selModel.getSelections()[0].get('OperateType');
        if(Operation=="U"){
            Operation="修改操作"            
        }
        if(Operation=="A"){
            Operation="添加操作"            
        }
        if(Operation=="D"){
            Operation="删除操作"            
        }
        if(rows.length>0)
        {
            var ClassUserName=grid.selModel.getSelections()[0].get('ClassName');
            if (ClassUserName!="User.BDPPreferences")   /// &&(ClassUserName!="User.BDPTableList"))
            {
				var height=Ext.getBody().getViewSize().height-30 ;
                var Log_Win = new Ext.Window
                ({
                    title:grid.selModel.getSelections()[0].get('ClassNameDesc')+"->"+Operation,
                    width :1100,
                    height :height,
                    layout : 'fit',
                    plain : true, 
                    modal : true,
                    frame : true,
                    // autoScroll : true,
                    constrain : true,
                    closeAction : 'hide'  
                    });
					var url="dhc.bdp.bdp.timeline.csp?actiontype=datadetail&id="+grid.selModel.getSelections()[0].get('ID');
					var url=encodeURI(url)
					if ('undefined'!==typeof websys_getMWToken)
					{
						url += "&MWToken="+websys_getMWToken() //增加token
					}  	
                    Log_Win.html='<iframe id="timeline" src=" '+url+' " width="100%" height="100%"></iframe>';
                    Log_Win.show();
                }
                else
                {
                    try
                    {
                        var OldValueJson=""
                        var redata =""
                        var record = grid.getSelectionModel().getSelected();
                        var id=record.get('ID');
                        var ShowOperate=record.get('OperateType'); 
                        var UserClass=record.get("ClassName");
                        var ClassNameDesc = record.get('ClassNameDesc');
                        var showTitleName=ClassNameDesc 
                        var returnJson=tkMakeServerCall("web.DHCBL.BDP.BDPDataChangeLog","GetDataDetail",id);
                        var objectJson=eval('(' + returnJson + ')');
                        var newdata =objectJson.NewValue    
                        /// 再次调用后台json数据 
                        
                        /// 正常情况下,NewValue 是非空的 
                        if (newdata!=""){
                            var jsondata = eval('(' + newdata + ')');
                            var newjson = "{";
                            var oldjson2="{";
                            var olddata= objectJson.OldValue     /// record.get('OldValue');        
                       
                             /// 原始数据存在  undefined 情况未处理？？捕获异常后抛出异常
                            if (olddata!=""){ 
                                //修改 :存在一种情况：操作是修改，但是没有OldValue,只有 NewValue
                                 var oldjson= eval('('+olddata+')')
                                 redata = [oldjson,jsondata]
                            }
                            else{
                                ////olddata 为空
                                 redata = [jsondata]
                            }
                            for(var x in jsondata)
                            {
                                
                                if (newjson!= "{")
                                {
                                    newjson = newjson + ","
                                }
                                if (oldjson2!= "{")
                                {
                                    oldjson2 = oldjson2 + ","
                                }
                                /// 获取属性
                                var Property=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropDescByCode",UserClass,x);
                                var PropertyData=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,jsondata[x]);
                                
                                PropertyData=PropertyData.substring(1,(PropertyData.length-1));
                             
                                var res = {fields:[{name:""+x+""}],columns:[{header:""+Property+"",dataIndex:""+x+"",width:130,sortable:true}]};  
                                var columns = res.columns;
                                var fields = res.fields;
                                for (var i = 0; i < fields.length; i++) {
                                    Detailfd.push(fields[i].name);
                                    DetailCM.push(columns[i]);
                                }
                                if(olddata!=""){
                                    var PropertyDataY=tkMakeServerCall("web.DHCBL.BDP.BDPTableList","GetPropValue",UserClass,x,oldjson[x]);
                                    PropertyDataY=PropertyDataY.substring(1,(PropertyDataY.length-1));
                                    // 原始数据与现数据进行比较
                                    if(PropertyDataY!=PropertyData)
                                    { ///bordeR-bottom:20px solid blue;   bordeR-bottom:20px solid red; 
                                        newjson = newjson + x+":"+'"<span style='+"'color:Red;bold:true;text-decoration:none'"+'>'+PropertyData +'</span>"' 
                                        oldjson2= oldjson2 + x+":"+'"<span style='+"'color:blue;bold:true; text-decoration:none'"+'>'+PropertyDataY +'</span>"' 
                                    }
                                    else
                                    {
                                        newjson = newjson + x+":"+'"'+PropertyData +'"' 
                                        oldjson2= oldjson2+ x+":"+'"'+PropertyDataY +'"'    
                                    }       
                                }
                                else{ /// 如果是 添加或者删除时，进行拼串
                                    newjson = newjson + x+":"+'"'+PropertyData +'"' 
                                }
                            }
                                var newjson = newjson + "}";
                                var newjsondata = eval('(' + newjson + ')');
                                
                                var oldjson = oldjson2 + "}";
                                var oldjson = eval('(' + oldjson + ')');
                                win.show();
                            }
                            else{
                                ///  newdata为空的情况 : 直接进入 异常捕获了，没有进行下一步的执行。  
                                Ext.getCmp('UpdateDataText').setValue(OldValue);
                            }
                            var ss=new Ext.data.JsonStore({ 
                                fields:Detailfd  
                            })  
                            DetailGrid.reconfigure(ss,new Ext.grid.ColumnModel(DetailCM));
                            Ext.BDP.FunLib.Newline(DetailGrid);
                            if(olddata!=""){
                                ss.loadData([oldjson,newjsondata]);  
                                win.setIconClass("icon-update")
                                win.setTitle(showTitleName+"      "+"修改数据：第一行为原始数据，第二行为修正后数据")
                            }
                            else{
                                if(ShowOperate=="U"){
                                    ss.loadData([newjsondata])
                                    win.setTitle(showTitleName+"     "+"修改数据：修正后数据")
                                    win.setIconClass("icon-update")
                                }
                                
                                if (ShowOperate=="A"){
                                    ss.loadData([newjsondata])
                                    win.setTitle(showTitleName+"     "+"添加数据")
                                    win.setIconClass("icon-add")
                                }
                               if (ShowOperate=="D"){
                                    ss.loadData([newjsondata])
                                    win.setTitle(showTitleName+"      "+"删除数据")
                                    win.setIconClass("icon-delete")
                                } 
                              }
                         }
                        catch (e) 
                        {
                            /// 捕获异常后
                            if((newdata!="")&&(ShowOperate=="U")){
                                Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata);
                            }
                            if((olddata!="")&&(ShowOperate=="U")){
                                Ext.getCmp('UpdateDataText').setValue(olddata+"->"+newdata); 
                            }
                            if((ShowOperate=="A")||(ShowOperate=="D")){
                                if(newdata!=""){
                                    Ext.getCmp('UpdateDataText').setValue(newdata); 
                            }
                        }
                        win2.show()  
                     }
                }
             }
    });
Ext.BDP.FunLib.Component.KeyMap(); 
Ext.BDP.FunLib.ShowUserHabit(grid,"User.BDPDataChangeLog");
/***********************************定义viewport容器*******************************/
var viewport = new Ext.Viewport({
        layout : 'border',
        items : [grid]
    });
});