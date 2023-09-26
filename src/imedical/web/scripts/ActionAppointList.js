Ext.QuickTips.init();

var url = '../web.eprajax.EPRAction.cls?Action=getunappointed&PatientID='+ patientID;

//取得授权申请列表数据源
function GetGridStore()
{
    //debugger;
	var store = new Ext.data.JsonStore({
        url:url,
        fields: [
           {name: 'EpisodeID'},
           {name: 'RequestCateCharpter'},
           {name:'RequestCCDesc'},
           {name: 'RequestUser'},
           {name: 'RequestDept'},
           {name: 'RequestDate'},
           {name: 'RequestTime'},
           {name: 'EPRAction'},
           {name: 'Name'},
           {name: 'AdmDate'},
           {name: 'AdmTime'},
           {name: 'MainDoc'},
           {name: 'CurDept'},
           {name:'AppointDate'},
           {name:'AppointTime'},
           {name:'AppointUser'},
           {name:'AppointType'},
           {name:'AppointSpan'},
           {name:'AppointCateCharpter'},
           {name: 'ID'}
        ]
    });
    
    //数据正常加载
    store.on('load', function () {
        var grid = Ext.getCmp('disAppointGrid');
        var total = store.getCount();
        
        for(var i=0;i<total;i++)
        {
            //若已经进行了授权,改变其背景色
            if(IsAppointed(store.getAt(i).data['AppointDate'],store.getAt(i).data['AppointTime']))
            {
                grid.getView().getRow(i).style.backgroundColor='#AAAAAA';
            }
        } 
    });
    
    //数据加载异常
    store.on('loadexception', function (proxy, options, response, e) {
        //debugger;
        alert(response.responseText);
    });
    
    return store;
}

//创建授权申请列表的Grid
function getGridPanel()
{
    //debugger;
    var store = GetGridStore();
    store.load();
    var sm = new Ext.grid.CheckboxSelectionModel({
        listeners:{
            'rowselect':function(record,index,e)
            {
                //选中对象触发的事件                
                ID = grid.getStore().getAt(index).data['ID'];
            }
        }
    });
    
    //增加患者姓名、就诊科室、就诊日期、主治医师及申请相关信息
    var cm = new Ext.grid.ColumnModel([sm,
        {header:'患者姓名',dataIndex:'Name',width:70},
        {header:'就诊科室',dataIndex:'CurDept',width:70},
        {header:'就诊日期',dataIndex:'AdmDate',width:70},
        {header:'就诊时间',dataIndex:'AdmTime',width:60,hidden:true},
        {header:'主治医师',dataIndex:'MainDoc',width:60},
        {header:'申请医师', dataIndex:'RequestUser',width:60},
        {header:'申请科室', dataIndex:'RequestDept',width:80},
        {header:'申请日期', dataIndex:'RequestDate',width:70},
        {header:'申请时间', dataIndex:'RequestTime',width:60},
        {header:'申请类型', dataIndex:'EPRAction', width:80,renderer:getAction}
    ]);
    
    var grid = new Ext.grid.GridPanel({
        id:'disAppointGrid',
        layout:'fit',
        store:store,
        cm:cm,
        sm:sm,
        forceFit:true,
        autoScroll:true,
        frame:true,
		tbar:['-',
		    {
		        id:'comboSpan',
                xtype:'combo',
                fieldLabel: '查看范围',
                name:'appointSpan',
                hiddenName:'value',
                mode: 'local',
                store: new Ext.data.SimpleStore({
                           fields:['value','text'],
                           data:[['getall','全部'],
                                 ['getunappointed','未授权'],
                                 ['getappointed','已授权']]
                }),
                valueField:'value',
                displayField:'text',
                typeAhead: true,
                triggerAction: 'all',
                emptyText:'请选择查看范围...',
                selectOnFocus:true
		            
		    },'-','->',
		    {
		        id:'btnConfirm',
		        xtype:'button',
		        text:'确定',
		        cls: 'x-btn-text-icon' ,
		        icon:'../scripts/epr/Pics/btnConfirm.gif',
		        pressed:false,
		        handler:getAppointList
		    },
		    '-']
    });
    
    return grid;
}

//转换操作代码为操作名称
function getAction(val)
{
    var retStr="";
    switch(val)
    {
        case 'view':
            retStr = '界面模板浏览';
            break;
        case 'save':
            retStr = '保存';
            break;
        case 'print':
            retStr = '打印';
            break;
        case 'commit':
            retStr = '提交';
             break;
        case 'switch':
            retStr = '选择模板';
             break;
        case 'switchtemplate':
            retStr = '更新模板';
            break;
        case 'chiefcheck':
            retStr = '主任医师签名';
            break;
        case 'attendingcheck':
            retStr = '主治医生签名';
            break;
        case 'browse':
            retStr = '病历浏览';
            break;
        default:
            retStr = val;
            break;
    }
    return retStr;
}

//获取授权申请列表
function getAppointList()
{
    //debugger;
    var combo = Ext.getCmp('comboSpan');
    var action = combo.getValue();
    var link = '../web.eprajax.EPRAction.cls?Action=' + action + '&PatientID='+ patientID;
    var s = Ext.getCmp('disAppointGrid').getStore();
    s.proxy.conn.url = link;
    s.load();
}

//生成授权申请详细信息Panel
function getDetailForm()
{
    //授权申请基本信息(申请日期时间、申请医师、审核日期时间、深恨医师等信息)
    var fsBasicInfo = {
            xtype:'fieldset',
            id:'fsBasicInfo',
            labelWidth: 60,
            labelAlign: 'right',
            title: '基本信息',
            collapsible: true,
            autoHeight:true,
            defaults: {width: 110},
            defaultType: 'textfield',
            items:[{
                id:'requestDate',
                fieldLabel: '申请日期',
                name: 'requestDate',
                disabled:true
            },{
                id:'requestTime',
                fieldLabel: '申请时间',
                name: 'requestTime',
                disabled:true
            },{
                id:'requestUser',
                fieldLabel: '申请医师',
                name: 'requestUser',
                disabled:true
            },{
                id:'requestDept',
                fieldLabel: '申请科室',
                name: 'requestDept',
                disabled:true
            },{
                id:'appointDate',
                fieldLabel: '审核日期',
                name: 'appointDate',
                disabled:true
            },{
                id:'appointTime',
                fieldLabel: '审核时间',
                name: 'appointTime',
                disabled:true
            },{
                id:'appointUser',
                fieldLabel: '审核医师',
                name: 'appointUser',
                disabled:true
            },{
                id:'actionType',
                xtype:'combo',
                fieldLabel: '操作类型',
                name:'actionType',
                hiddenName:'value',
                mode: 'local',
                store: new Ext.data.SimpleStore({
                           fields:['value','text'],
                           data:[['view','界面模板浏览'],
                                 ['save','保存'],
                                 ['print','打印'],
                                 ['commit','提交'],
                                 ['switch','切换模板'],
                                 ['switchtemplate','更新模板'],
                                 ['chiefcheck','主任医师签名'],
                                 ['attendingcheck','主治医生签名'],
                                 ['browse','病历浏览']]
                }),
                valueField:'value',
                displayField:'text',
                typeAhead: true,
                triggerAction: 'all',
                emptyText:'请选择操作类型...',
                selectOnFocus:true
            },{
                id:'appointType',
                xtype:'combo',
                fieldLabel: '授权类型',
                name:'appointType',
                hiddenName:'value',
                mode: 'local',
                store: new Ext.data.SimpleStore({
                           fields:['value','text'],
                           data:[['0','个人'],
                                 ['1','科室']]
                }),
                valueField:'value',
                displayField:'text',
                typeAhead: true,
                triggerAction: 'all',
                emptyText:'请选择授权类型...',
                selectOnFocus:true
            },{
                id:'appointSpan',
                fieldLabel: '授权时间(小时)',
                regex: /^([1-9][0-9]{0,2}(\.[0-9][1-9]?)?)$|^(0\.[0-9][1-9]?)$/,
                regexText:'用户格式错误',   //javascript正则表达式验证失败错误信息提示
                name: 'appointSpan'
            }]
        };
        
    //申请病历范围
    var fsRange = new Ext.form.FieldSet({
        id:'fsRange',
        labelWidth:2,
        labelAlign:'right',
        title: '申请范围',
        collapsible: true,
        autoScroll:true,
        autoHeight:true,
        defaultType: 'checkbox'
        //layout:'column',
        //height:300,
    });
        
    var detailForm = new Ext.FormPanel({
        id:'detailForm',
        frame:true,
        autoScroll:true,
        bodyStyle:'padding:5px 5px 0',
        //width: 500,
        //layout:'fit',
        items: [
            fsBasicInfo,
            fsRange
        ],
        tbar:['->','-',
		     {id:'btnCommit',name:'btnCommit',text:'提交',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false,handler:commitAppoint}]
	});
	 
    
    detailForm.doLayout();
    return detailForm;
}

//提交审核信息
function commitAppoint()
{
    if (ID == "")
    {
        Ext.MessageBox.alert('操作提示','请选中一条记录再提交申请');
        return;
    }
    
    //操作类型
    var action = Ext.getCmp('actionType').getValue();
    if(action=="")
    {
        Ext.MessageBox.alert('操作提示','请选择操作类型再提交申请');
        return;
    }
    //授权类型                      
    var appointType = Ext.getCmp('appointType').getValue();	
    if(appointType=="")
    {
        Ext.MessageBox.alert('操作提示','请选择授权类型再提交申请');
        return;
    }
    //授权时长		    
    var span = Ext.getCmp('appointSpan').getValue();                
	var appointSpan = 3600 * parseFloat(span).toString();
    if(appointSpan=="")
    {
        Ext.MessageBox.alert('操作提示','请指定授权时长再提交申请');
        return;
    }
    
    var count=0;
    var appointCateCharpter = "";
    var field = Ext.getCmp('fsRange');
    for(var i=0; i<field.items.items.length; i++)
    {
        if(field.items.items[i].checked)
        {
            if(count==0)
            {
                appointCateCharpter = field.items.items[i].id;
            }
            else
            {
                appointCateCharpter = appointCateCharpter + '^' + field.items.items[i].id;
            }
            count++;
        }
    }
    Ext.Ajax.request({			
		url: '../web.eprajax.EPRAction.cls',
		timeout : 5000,
		params: { Action:"appoint",ID:ID,AppointSpan:appointSpan,AppointCateCharpter:appointCateCharpter,AppointUserID:appointUserID,EPRAction:action,AppointType:appointType},
		success: function(response, opts) {
		    //debugger;
			if(response.responseText=="1")
			{
			    //授权操作成功，更新待授权列表
			    var s = Ext.getCmp('disAppointGrid').getStore();
	            s.proxy.conn.url = url;
	            s.load();
	            
	            //重新初始化控件的值
	            ID = "";
	            Ext.getCmp('requestDate').setValue("");
	            Ext.getCmp('requestTime').setValue("");
	            Ext.getCmp('requestUser').setValue("");
	            Ext.getCmp('requestDept').setValue("");
	            Ext.getCmp('appointDate').setValue("");
	            Ext.getCmp('appointTime').setValue("");
	            Ext.getCmp('appointUser').setValue("");
	            Ext.getCmp('actionType').reset();
                Ext.getCmp('appointType').reset();
                Ext.getCmp('appointSpan').setValue("");
                //重新初始化fsRange
                detail.remove(Ext.getCmp('fsRange'), true);
                var field = new Ext.form.FieldSet({
                    id: 'fsRange',
                    labelWidth: 0,
                    title: '申请范围',
                    collapsible: true,
                    autoScroll: true,
                    autoHeight: true,
                    defaultType: 'checkbox'
                });
                detail.add(field);
	            /*
	            for(var i=0; i<field.items.items.length; i++)
                {
                    field.items.items[i].setValue(false);
                }
                */
			}
			else
			{
			    Ext.MessageBox.alert('操作提示', '申请权限操作提交失败');
		    }
		},
		failure: function(response, opts) {
			Ext.MessageBox.alert("提示",response.responseText);
		}
	}); 
}

var grid = getGridPanel();
var detail = getDetailForm();

var view = new Ext.Viewport({
	id: 'viewport',
	shim: false,
	animCollapse: false,
	constrainHeader: true, 
	collapsible: true,
	margins:'0 0 0 0',           
	layout: "border",  
	border: false,              
	items: [{
		border:false,
		region:'west',
		layout:'fit',
		split: true,
		collapsible: true,  
		width:680,
		items:grid
    },{
        border:false,
        region:'center',
        layout:'fit',
        split:true,
        collapsible:true,
        width:250,
        items:detail
    }]
});

//处理授权申请列表双击事件
grid.on('rowdblclick',function(g,index,e)
{
    //是否只选中一条记录
    if (!IsSelectedRecordOK()) return;
    
	//获取选中授权申请记录信息
	var record = g.getStore().getAt(index);
	ID = record.data['ID'];
	requestCateCharpter = record.data['RequestCateCharpter'];
	requestCateCharpterDesc = record.data['RequestCCDesc'];
	requestUser = record.data['RequestUser'];
	requestDept = record.data['RequestDept'];
	action = record.data['EPRAction'];
	var appointDate = record.data['AppointDate'];
	var appointTime = record.data['AppointTime'];
	var appointCateCharpter =  record.data['AppointCateCharpter'];
	
	//授权申请信息(申请相关)
	Ext.getCmp('requestDate').setValue(record.data['RequestDate']);
	Ext.getCmp('requestTime').setValue(record.data['RequestTime']);
	Ext.getCmp('requestUser').setValue(record.data['RequestUser']);
	Ext.getCmp('requestDept').setValue(record.data['RequestDept']);
	Ext.getCmp('actionType').setValue(record.data['EPRAction']);
	
	//授权申请信息(审核相关)
	if(IsAppointed(appointDate,appointTime))
	{
	    //已审核
	    Ext.getCmp('appointDate').setValue(record.data['AppointDate']);
	    Ext.getCmp('appointTime').setValue(record.data['AppointTime']);
	    Ext.getCmp('appointUser').setValue(record.data['AppointUser']);
	    Ext.getCmp('appointType').setValue(record.data['AppointType']);
	    Ext.getCmp('appointSpan').setValue(record.data['AppointSpan']);
	    //病历范围
	    setCateChapterInfo(requestCateCharpter,requestCateCharpterDesc,appointCateCharpter,true);
	    //禁用提交按钮
	    Ext.getCmp('btnCommit').setDisabled(true);
	}
	else
	{
	    //未审核
	    Ext.getCmp('appointDate').setValue("");
	    Ext.getCmp('appointTime').setValue("");
	    Ext.getCmp('appointUser').setValue("");
	    Ext.getCmp('appointType').reset();
	    Ext.getCmp('appointSpan').setValue("");
	    //病历范围
	    setCateChapterInfo(requestCateCharpter,requestCateCharpterDesc,appointCateCharpter,false);
	    //启用提交按钮
	    Ext.getCmp('btnCommit').setDisabled(false);
	}
	
});

function setCateChapterInfo(requestCC, requestCCDesc, appointCC, isAppointed){
    //debugger;
	
	//重新初始化fsRange
	detail.remove(Ext.getCmp('fsRange'),true);
	var field = new Ext.form.FieldSet({
        id:'fsRange',
        labelWidth:0,
        title: '申请范围',
        collapsible: true,
        autoScroll:true,
        autoHeight:true,
        defaultType: 'checkbox'
    });
    detail.add(field);
	
	//为fsRange添加申请范围
	var aryCCId = requestCC.split('^');
	var aryCCDesc = requestCCDesc.split('^');
	for (var i=0; i<aryCCId.length; i++)
	{
	    var checkbox = new Ext.form.Checkbox();
        checkbox.id = aryCCId[i];
        checkbox.boxLabel = aryCCDesc[i];
        checkbox.labelSeparator  = '';
        checkbox.hideLabel = true; 
        //checkbox.columnWidth=1;
        
        field.add(checkbox);
	}
	
	if (isAppointed)
	{
	    var tmp = "^" + appointCC + "^";
	    //只选中fsRange申请范围中被审核的项目
	    for(var i=0; i<field.items.items.length; i++)
        {
            if(tmp.indexOf('^'+field.items.items[i].id+'^') != -1)
            {
                field.items.items[i].setValue(true);
            }
            field.items.items[i].setDisabled(true);
        }
	}
	else
	{
	    //选中fsRange申请范围所有项目
	    for(var i=0; i<field.items.items.length; i++)
        {
            field.items.items[i].setValue(true);
        }
    }
    
    detail.doLayout();
 }
 
 //是否只选中了一条授权申请记录
 function IsSelectedRecordOK()
 {
    var selModel = Ext.getCmp('disAppointGrid').getSelectionModel();
	var selects = selModel.getSelections();
	
	if(selects.length == 0)
	{
		alert('请选择一条记录进行授权操作!');
		return false;
	}
	else if(selects.length>1)
	{
	    alert('已选择了'+selects.length+'条记录,只能选择一条记录进行授权操作!');
	    return false;
	}
	else
	{
	    return true;
	}
 }
 
 //选中授权申请记录是否已经被审核过
 function IsAppointed(appointDate, appointTime)
 {
    if (appointDate == "1840-12-31" || appointDate == "") return false;
    if (appointTime == "00:00:00" || appointTime == "") return false;
    return true;
 }

