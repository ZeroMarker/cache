
//确定
function confirm() {
    if (selectNode == null) {
        return;
    }
    if (selectNode.id == "RT0") {
        return;
    }
    if (!selectNode.isLeaf()) {
        parentId = selectNode.id;
        categoryChapterId = ""
    }
    else {
        parentId = selectNode.parentNode.id;
        categoryChapterId = selectNode.id;
    }
    Ext.getCmp('cboEprRecord').setValue(selectNode.text);
}

//浏览
function browser() {
    //document.getElementById('divDateTimeSelect').style.top = 0;
    //return;
    if (parentId == "") {
        alert('请先选择要浏览的病历!');
        return;
    }


    /*
    if (!parent.frames['centerTab'].frames['centerTabDetial'] && !parent.frames['centerTab'].frames['centerTabListDetial'])
    {
    alert('请先打开一个病历书写界面,然后再进行浏览操作!');
    return;
    }
    */

    document.getElementById('divDateTimeSelect').style.top = 0;

    frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = "请稍候...";
    //初始化起始页和终止页
    var count = parseInt(Ext.getCmp("cboBrowerCount").value, 10);
    startIndex = 1;
    endIndex = count;

    var startDate = Ext.getCmp('startDate').value;
    var endDate = Ext.getCmp('endDate').value;

    var startTime = Ext.getCmp('startTime').value;
    var endTime = Ext.getCmp('endTime').value;

    imageList = "";

    arrTmp = null;
    arrTmp = new Array();

    //add by zhuj on 2009-12-24 begin
    arrCurrPageCount = null;
    arrCurrPageCount = new Array();
    currPage = 1;
    currDownPage = 0;
    //end


    total = 0;

    if (parentId == '') {
        frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = "";
        return;
    }

    //异步获得打印模板id集合
    Ext.Ajax.request({
        url: '../web.eprajax.eprBorwser.printTemplateId.cls',
        timeout: parent.parent.timedOut,
        params: { parentId: parentId.substring(2, parentId.length), categoryChapterId: categoryChapterId, startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, episodeID: episodeID, patientID: patientID },
        success: function(response, opts) {
            imageList = response.responseText;
            //alert(imageList);
            if (imageList == 'NoPower') {
                frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = "对不起,您没有浏览权限!";
                return;
            }
            if (imageList == 'docIdListnull') {
                //alert('没有找到相关图片!错误代码:docIdList null');
                frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = "没有找到相关病历!";
                return;
            }
            if (imageList == 'logIdListnull') {
                //alert('没有找到相关图片!错误代码:logIdList null');
                frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = "没有找到相关病历!";
                return;
            }

            if (imageList == "") {
                //alert("获取图片集合失败!错误代码:imageList null");
                frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = "没有找到相关病历!";
            }
            else {
                total = parseInt(imageList.split('$')[0], 10);
                queryPhoto(imageList);
            }
        },
        failure: function(response, opts) {
            alert(response.responseText);
        }
    });
}

//调用dll下载图片
function queryPhoto(imageList) {
    var path = "";
    
    //path = document.getElementById('imageloader').GetPreviewImage(patientID, episodeID, imageList, startIndex, endIndex);
    path = frames['frameBrowserPhoto'].document.getElementById('imageloader').GetPreviewImage(patientID, episodeID, imageList, startIndex, endIndex);
    
    if (path != "") {
        var arr = path.split('^');
        var table = '<table cellpadding="0" cellspacing="0">';
        var picLength = arr.length;
        for (var i = 0; i < picLength; i++) {
            table += '<tr><td><img src="' + arr[i] + '"/></td></tr>'
            //将arrTmp[i + arrTmp.length] = arr[i] 该为arrTmp = arrTmp.concat(arr[i]), 2009-9-7
            //arrTmp[i + arrTmp.length] = arr[i];
            arrTmp = arrTmp.concat(arr[i]);
        }
        table += '</table>'
        frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = table;
        //debugger;
        arrCurrPageCount = arrCurrPageCount.concat(picLength); 	//add by zhuj on 2009-12-24
        currDownPage++;
        //debugger;
        //点击浏览后将按钮下一页Enable设置为True
        Ext.getCmp('btnNext').enable();
        if (endIndex >= total) {
            Ext.getCmp('btnNext').disable();
        }

    }

}

//上一页
function prev() {
    //开始页小于1,直接返回
    if (startIndex <= 1) {
        Ext.getCmp('btnPreview').disable();
        return;
    }

    //点击时将按钮下一页Enable设置为True
    Ext.getCmp('btnNext').enable();

    var count = parseInt(Ext.getCmp("cboBrowerCount").value, 10);
    startIndex = startIndex - count;
    endIndex = endIndex - count;

    //add by zhuj on 2009-12-24 begin
    currPage--;
    var cacheStart = 1;
    var cacheEnd = 1;
    for (var i = 0; i < currPage - 1; i++) {
        cacheStart += arrCurrPageCount[i];
    }
    cacheEnd = cacheStart + arrCurrPageCount[currPage - 1];
    //end

    //读取缓存中的数据
    var table = '<table cellpadding="0" cellspacing="0">'
    for (var i = cacheStart - 1; i < cacheEnd - 1; i++) {
        table += '<tr><td><img src="' + arrTmp[i] + '"/></td></tr>';
    }
    table += '</table>';
    frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = table;

    //开始页小于1,将其禁用掉
    if (startIndex <= 1) {
        Ext.getCmp('btnPreview').disable();
    }

}

//下一页
function next() {
    if (endIndex >= total) {
        Ext.getCmp('btnNext').disable();
        return;
    }
    Ext.getCmp('btnPreview').enable();

    var count = parseInt(Ext.getCmp("cboBrowerCount").value, 10);
    startIndex = startIndex + count;
    endIndex = endIndex + count;


    currPage++; 	//add by zhuj on 2009-12-24


    //读取缓存中的数据
    if (currPage <= currDownPage) {
        //add by zhuj on 2009-12-24 begin
        var cacheStart = 1;
        var cacheEnd = 1;
        for (var i = 0; i < currPage - 1; i++) {
            cacheStart += arrCurrPageCount[i];
        }
        cacheEnd = cacheStart + arrCurrPageCount[currPage - 1];
        //end

        var table = '<table cellpadding="0" cellspacing="0">';
        //将endIndex-1 替换为 arrTmp.length - 1,2009-9-7
        for (var i = cacheStart - 1; i < cacheEnd - 1; i++) {
            table += '<tr><td><img src="' + arrTmp[i] + '"/></td></tr>';
        }
        table += '</table>';
        frames['frameBrowserPhoto'].document.getElementById('browserPhoto').innerHTML = table;
    }
    else {
        queryPhoto(imageList);
    }

    if (endIndex >= total) {
        Ext.getCmp('btnNext').disable();
    }
}

//鼠标点击到'日期选择'上的方法
function sltDT() {
    var top = document.getElementById('divDateTimeSelect').style.top;

    if (top == '0px') {
        Ext.get('divDateTimeSelect').shift({
            y: 28
        });
    }
    else if (top == '28px') {
        Ext.get('divDateTimeSelect').shift({
            y: 0
        });
    }

}



//创建树形菜单
function getBorwserTree(episodeID)
{
	//debugger;
    var Tree = Ext.tree;
    var treeLoader = new Tree.TreeLoader( {dataUrl : "../web.eprajax.browserTree.cls?EpisodeID=" + episodeID});
    //抛出异常时的处理				
	treeLoader.on("loadexception", function(tree, node, response) {
		var obj = response.responseText;
		alert(obj);
	});
    var tree = new Tree.TreePanel({
		rootVisible: true,
		autoScroll:true,
		animate:false,
		//enableDD:true,
		containerScroll:true,
		lines:true, 
		checkModel:'cascade',
		autoHeight:true,
		border:false,
		loader : treeLoader,
		id:"browserTree"
    });
      
    var root = new Tree.AsyncTreeNode( {
		text : '电子病历',
		nodeType: 'async',
		draggable : false,
		id : "RT0"
    });	


    tree.on('click',function(node,event){
		selectNode = node;
    }); 

    tree.setRootNode(root);
    root.expand(); 
    return tree;
}

//创建界面
function createToolBar()
{
	//debugger;
	new Ext.Toolbar({renderTo: 'pagetoolbar', items:['-',
		{ id : 'cboEprRecord',listWidth: 170, resizable: false, xtype :'combo', width: 120, readOnly: true, mode: 'local',store: new Ext.data.SimpleStore({ fields:[], data:[[]]}),
			tpl: '<tpl for="."><div id="divTree" style="height: 200px;"><div id="divBrowserTree"></div></div></tpl>',
			valueField: "retrunValue", displayField: "displayText",blankText: '请选择查询条件', 
			emptyText: '请选择查询条件',editable : false, triggerAction : 'all', allowBlank : false},
		{id:'btnConfirm',text:'确定',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/btnConfirm.gif',pressed:false, handler: confirm},	
		'-',	
		{id:'btnSltDate',text:'选择日期......',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/Calendar.png',pressed:false, listeners:{'click': function(){sltDT();}}},
		'-',
		{id:'btnBrower',text:'浏览',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/browser.gif',pressed:false,handler:browser},
		'->',		
		'-',
		' 每次 ',
		{ id : 'cboBrowerCount',xtype:'combo', width : 50, readOnly : true,mode: 'local',
				valueField: 'retrunValue', displayField: 'displayText',editable : false, 
				triggerAction : 'all', allowBlank : false,value: '10',
				store: new Ext.data.SimpleStore
					({
						fields: ['retrunValue', 'displayText'],
						data: [['1', '1'],['3', '3'],['5', '5'],['10', '10'],['30', '30'],['50', '50']]
					})},
		' 条 ',
		'-',		
		{id:'btnPreview',text:'上一页',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/pageupbrowser.gif',pressed:false,handler:prev},
		{id:'btnNext',text:'下一页',cls: 'x-btn-text-icon' ,icon:'../scripts/epr/Pics/pagedownbrowser.gif',pressed:false,handler:next},
		'-'
	]});

		

	new Ext.Toolbar({renderTo: 'divDateTimeSelect', items:['-',
		'->',
		{ xtype : 'datefield', id : 'startDate', width : 90, readOnly : false, format : 'Y-m-d', minValue: '1980-01-01' },
		{ xtype : 'timefield', id : 'startTime', width : 55, readOnly : false, format : 'H:00', increment: 60, editable: false, value: '00:00' },	
		' 至 ',
		{ xtype : 'datefield', id : 'endDate', width : 90, readOnly : false, format : 'Y-m-d' },
		{ xtype : 'timefield', id : 'endTime', width : 55, readOnly : false, format : 'H:00', increment: 60, editable: false, value: '23:00' },	
		'-'		
	]});

	//设置日期控件的时间
	if (dateInBed == '1840-12-31')
	{			
		Ext.getCmp('startDate').setValue('1980-01-01');	
	}
	else
	{
		Ext.getCmp('startDate').setValue(dateInBed);	
	}

	if (disBed == '1840-12-31')
	{
		var date = new Date();
		Ext.getCmp('endDate').setValue(date);	
	}
	else
	{
		Ext.getCmp('endDate').setValue(disBed);	
	}

	Ext.getCmp('btnPreview').disable();
	Ext.getCmp('btnNext').disable();

	Ext.getCmp('cboBrowerCount').on('select', function(combo, record, number){
		Ext.getCmp('btnPreview').disable();
		Ext.getCmp('btnNext').disable();
	});

	Ext.getCmp('cboEprRecord').on('Expand', function(){
		if(!Ext.getCmp('browserTree'))
		{
			getBorwserTree(episodeID).render('divBrowserTree');
			//document.getElementById('divTree').parentElement.parentElement.style.width="170px";
			//document.getElementById('divTree').parentElement.style.width="170px";
		}
		else
		{
			Ext.getCmp('browserTree').root.reload();
		}
		
	});
}

createToolBar();		//创建界面