var userid = session['LOGON.USERID'];
var userdept = session['LOGON.CTLOCID'];

////////////////  多表头  ///////////////////////
var row = [
 	{ header: '', colspan: 1, align: 'center' },  
    { header: '', colspan: 2, align: 'left' },//header表示父表头标题，colspan表示包含子列数目  
    { header: '指标类别', colspan: 3, align: 'right' },
    { header: '科目名称', colspan: 1, align: 'left' },  
    { header: '单位', colspan: 1, align: 'center' },  
    { header: '前年', colspan: 2, align: 'center' }, 
    { header: '去年', colspan: 4, align: 'center' },
    { header: '本年度', colspan: 3, align: 'center' }
     
   ];  
var group = new Ext.ux.grid.ColumnHeaderGroup({  
       rows: [row]  
   }); 


// ///////////年度/////////////////////////
var smYearDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYearDs.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemmamainexe.csp?action=yearList',
						method : 'POST'
					});
		});

var yearCombo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYearDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 150,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
// ///////////年度/////////////////////////
var smYear2Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

smYear2Ds.on('beforeload', function(ds, o) {

			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgschemmamainexe.csp?action=yearList',
						method : 'POST'
					});
		});

var year2Combo = new Ext.form.ComboBox({
			fieldLabel : '年度',
			store : smYear2Ds,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 150,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
// ////////////科室名称////////////////////////
var deptDs = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

deptDs.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgtempexe.csp?action=caldept&userid='+userid,
						method : 'POST'
					});
		});

var deptCombo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : deptDs,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});
		
// ////////////科室名称////////////////////////
var dept2Ds = new Ext.data.Store({
			proxy : "",
			reader : new Ext.data.JsonReader({
						totalProperty : "results",
						root : 'rows'
					}, ['rowid', 'name'])
		});

dept2Ds.on('beforeload', function(ds, o) {
			ds.proxy = new Ext.data.HttpProxy({
						url : 'herp.budg.budgtempexe.csp?action=caldept&userid='+userid+'&userdept='+userdept,
						method : 'POST'
					});
		});

var dept2Combo = new Ext.form.ComboBox({
			fieldLabel : '科室名称',
			store : dept2Ds,
			displayField : 'name',
			valueField : 'rowid',
			typeAhead : true,
			forceSelection : true,
			triggerAction : 'all',
			emptyText : '',
			width : 120,
			listWidth : 245,
			pageSize : 10,
			minChars : 1,
			columnWidth : .1,
			selectOnFocus : true
		});

var findButton = new Ext.Toolbar.Button({
	text: '查询',
	tooltip: '查询',
	iconCls: 'option',
	handler: function(){
	
	      		var Year = yearCombo.getValue();
				var DName = deptCombo.getValue();
				if(Year==""){
					Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return;
				}
				if(DName==""){
					Ext.Msg.show({title:'注意',msg:'请选择科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return;
				}
				itemGrid.load({params : {start : 0,limit : 25,Year : Year,Dept : DName,userid:userid}});
	}
});


///////打印按钮
var printButton = new Ext.Toolbar.Button({
    text : '打印',
	tooltip : '点击打印报销单',
	width : 70,
	height : 30,
	iconCls : 'print',
	handler : function() {
	//var selectedRow = itemGrid.getSelectionModel().getSelections();
	
	//var rowidm=selectedRow[0].data['ItemCode'];
	var Year = yearCombo.getValue();
	var DName = deptCombo.getValue();
	//alert(billcode);
	if(Year==""){
					Ext.Msg.show({title:'注意',msg:'请选择年度!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return;
				}
				if(DName==""){
					Ext.Msg.show({title:'注意',msg:'请选择科室!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.INFO});
					return;
	}

	fileName="{HERPBUDGIndexDeptReqPrint.raq(USERID="+userid+";Year="+Year+";Dept="+DName+")}";
	//billcode="BC2015010121"
	//fileName="{herp.budg.report.budgctrlpaybillprint.raq(billcode1="+billcode+")}";
	//alert("as");
	DHCCPM_RQDirectPrint(fileName);

    }
});

var ExcelButton = new Ext.Toolbar.Button({
	text: 'Excel导出',
	tooltip: 'Excel导出',
	iconCls: 'option',
	handler: function(){
	      	ExportExcel(itemGrid);
	}
});

var itemGrid = new dhc.herp.Grid({
        title: '相关人次信息维护',
        width: 400,
        //edit:false,                   //是否可编辑
        //readerModel:'local',
        region: 'center',
        layout:"fit",
		split : true,
		collapsible : true,
		xtype : 'grid',
		trackMouseOver : true,
		stripeRows : true,
		//loadMask : true,
		//atLoad: true,
		trackMouseOver: true,
		stripeRows: true,
        url: 'herp.budg.budgtempexe.csp',
		tbar : ['年度:', yearCombo, '科室名称:', deptCombo, '-', findButton,'-',ExcelButton],
        plugins: group,
        fields: [{
            header: 'ID',
            dataIndex: 'rowid',
			edit:false,
            hidden: true
        },{
            id:'CompName',
            header: '医疗单位',
			calunit:true,
			editable:false,
			allowBlank: false,
			width:120,
			hidden: true,
            dataIndex: 'CompName'
        },{
            id:'Year',
            //header: '年度',
			allowBlank: false,
			width:60,
			editable:true,
			hidden:true,
            dataIndex: 'Year',
            editable:false
        }, {
            id:'IdxType',
            //header: '指标类别',
			allowBlank: true,
			width:80,
			editable:true,
            dataIndex: 'IdxType',
           	editable:false
        },{
           id:'ItemCode',
            header: '科目编码',
			allowBlank: true,
			width:200,
			hidden:true,
            dataIndex: 'ItemCode',
            editable:false
        },{
           id:'ItemName',
            //header: '科目',
			allowBlank: true,
			width:200,
            dataIndex: 'ItemName',
            editable:false
        },{
            id:'UnitName',
            //header: '单位',
			allowBlank: true,
			width:40,
			editable:false,
            dataIndex: 'UnitName'
        },{
            id:'PreLastPlanValue',
            header: '前年预算',
			allowBlank: true,
			xtype:'numbercolumn',
			width:120,
            dataIndex: 'PreLastPlanValue',
            editable:false
        },{
            id:'PreLastExeValue',
            header: '前年执行',
            xtype:'numbercolumn',
			allowBlank: true,
			width:120,
            dataIndex: 'PreLastExeValue',
            editable:false
        },{
            id:'LastPlanValue',
            header: '预算',
            xtype:'numbercolumn',
			allowBlank: true,
			width:120,
            dataIndex: 'LastPlanValue',
            editable:false
        },{
            id:'Last9ExeValue',
            header: '1-9月执行',
            xtype:'numbercolumn',
			allowBlank: true,
			width:120,
            dataIndex: 'Last9ExeValue',
            editable:false
        },{
            id:'Last10PlanValue',
            header: '10-12月预算',
			allowBlank: true,
			width:120,
            dataIndex: 'Last10PlanValue',
            editable:false
        },{
            id:'diffrate1',
            header: '增长率(%)',
			allowBlank: true,
			width:70,
            dataIndex: 'diffrate1',
            editable:false
        },{
            id:'PlanValue',
            header: '预算',
			allowBlank: true,
			xtype:'numbercolumn',
			width:120,
            dataIndex: 'PlanValue',
			align : 'right',
			overrender: true,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
					cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
					return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
				},
            editable:true
        },{
            id:'diffrate2',
            header: '增长率(%)',
			allowBlank: true,
			width:70,
            dataIndex: 'diffrate2',
            editable:false
        },{
            id:'ChkDesc',
            header: '填报说明',
			allowBlank: true,
			width:120,
            dataIndex: 'ChkDesc',
			overrender: true,
			renderer : function(value,cellmeta, record,rowIndex, columnIndex, store) {
					cellmeta.css="cellColor2";// 设置可编辑的单元格背景色
					return '<span style="color:brown;cursor:hand;backgroundColor:red">'+value+'</span>';
				},
            editable:true
        }]
    
    });

	itemGrid.btnResetHide();
	itemGrid.btnPrintHide();
	itemGrid.btnAddHide();
	itemGrid.btnDeleteHide();
	itemGrid.addButton('-');
	itemGrid.addButton(printButton);
	//itemGrid.addButton('-');
	//itemGrid.addButton(ExcelButton);
	
Ext.ux.clone = function (obj) {
    if (obj == null || typeof (obj) != 'object')
        return obj;
    if (Ext.isDate(obj))
        return obj.clone();
    var cloneArray = function (arr) {
        var len = arr.length;
        var out = [];
        if (len > 0) {
            for (var i = 0; i < len; ++i)
                out[i] = Ext.ux.clone(arr[i]);
        }
        return out;
    };
    var c = new obj.constructor();
    for (var prop in obj) {
        var p = obj[prop];
        if (Ext.isArray(p))
            c[prop] = cloneArray(p);
        else if (typeof p == 'object')
            c[prop] = Ext.ux.clone(p);
        else
            c[prop] = p;
    }
    return c;
};	
	
//Excel导出
function ExportExcel(itemGrid, config) {
    if (itemGrid) {
        var tmpStore = itemGrid.getStore();
        
        var tmpExportContent = '';

        //以下处理分页grid数据导出的问题，从服务器中获取所有数据，需要考虑性能
        var tmpParam = Ext.ux.clone(tmpStore.lastOptions); //此处克隆了原网格数据源的参数信息

        if (tmpParam && tmpParam.params) {
            //delete (tmpParam.params[tmpStore.paramNames.start]); //删除分页参数
            //delete (tmpParam.params[tmpStore.paramNames.limit]);
             tmpParam.params[tmpStore.paramNames.start]=0; 
             tmpParam.params[tmpStore.paramNames.limit]=1000;
        }
        var tmpAllStore = new Ext.data.GroupingStore({//重新定义一个数据源
            proxy: tmpStore.proxy,
            reader: tmpStore.reader
        });
        tmpAllStore.on('load', function (store) {
         
          var xls = new ActiveXObject("Excel.Application");
          var xlBook = xls.Workbooks.Add;      //新增工作簿
          var xlSheet = xlBook.Worksheets(1); //创建工作表
          var cm = itemGrid.getColumnModel();
   		  var colCount = cm.getColumnCount();  
   		  //alert(colCount);
      	  var temp_obj = [];
    
  		 // 只下载没有隐藏的列(isHidden()为true表示隐藏,其他都为显示)    
   		for (i = 1; i < colCount; i++) {
    		if (cm.isHidden(i) == true) {
    		} else {
     		temp_obj.push(i);   
     		}
   		}
		for (var i=4;i<=5;i++){
			for (var j=1;j<=temp_obj.length;j++){
				 xlSheet.Cells(i, j).Borders.Weight = 2;
				}
			}
		xls.Range("A1:L1").MergeCells = true;
		xlSheet.Cells(1, 1).Value ="收 入 业 务 计 划 表";
		xlSheet.Cells(1, 1).Font.Name = "宋体"; 
		xlSheet.Cells(1, 1).Font.Bold = true; 
		xlSheet.Cells(1, 1).Font.Size = 15;
		xlSheet.Cells(1,1).HorizontalAlignment = 3; 
		xls.Range("A2:L2").MergeCells = true;
		xlSheet.Cells(2, 1).Value ="预算年度："+yearCombo.getValue()+" 年";
		xlSheet.Cells(2,1).HorizontalAlignment = 3;
		xlSheet.Cells(3, 1).Value = "编制单位："
		xlSheet.Cells(3, 2).Value = "科室负责人："
		xlSheet.Cells(3, 3).Value = "主管领导："
		xls.Range("C3:E3").MergeCells = true;
		xlSheet.Cells(3, 6).Value = "提交时间："
		xls.Range("F3:I3").MergeCells = true;
   	    xlSheet.Cells(4, 1).Value ="指标类别";
   	    xlSheet.Cells(4,1).HorizontalAlignment = 3; //控制单元格居中
   	    xlSheet.Cells(4, 2).Value ="科目类别";
   	    xlSheet.Cells(4,2).HorizontalAlignment = 3;	    
   	    xlSheet.Cells(4, 3).Value ="单位";
   	    xlSheet.Cells(4,3).HorizontalAlignment = 3;    	   
   	    xls.Range("D4:E4").MergeCells = true;//合并单元格
   	    xlSheet.Cells(4, 4).Value ="前年";
   	    xlSheet.Cells(4,4).HorizontalAlignment = 3;
   	    xls.Range("F4:I4").MergeCells = true;
   	    xlSheet.Cells(4, 6).Value ="去年";
   	    xlSheet.Cells(4,6).HorizontalAlignment = 3; 
   	    xls.Range("J4:L4").MergeCells = true;
   	    xlSheet.Cells(4, 10).Value ="本年度";
   	    xlSheet.Cells(4,10).HorizontalAlignment = 3; 
 
   		for (l = 2; l <= temp_obj.length; l++) {
	   			
    			xlSheet.Cells(5, l).Value = cm.getColumnHeader(temp_obj[l-1]); 
   			}
    			
   				var recordCount = store.getCount();
   				//alert("记录总数："+recordCount);
   				//alert('总列数：'+temp_obj.length);
   				var view = itemGrid.getView();
   				var tempstr=""
   				for (k = 1; k <= recordCount; k++) {
   					//alert('k-'+k);
   					//alert(view.getCell(k - 1, temp_obj[0]).innerText)
    				for (j = 1; j <= temp_obj.length; j++) {
     				// EXCEL数据从第二行开始,故row = k + 1;
    				if((j==1)&&(tempstr==view.getCell(k - 1, temp_obj[0]).innerText)){
		    				xlSheet.Cells(k + 5, j).Borders.Weight = 2;//添加边框
		    				var y=k+4;
		    				var m=k+5;
		    				if(k>1){
		    				xls.Range("A"+y,"A"+m).MergeCells = true;
		    				}
		    				continue;
	    				}
     		        tempstr=view.getCell(k - 1, temp_obj[0]).innerText;
	     		    xlSheet.Cells(k + 5, j).Value = view.getCell(k - 1, temp_obj[j- 1]).innerText;
     				xlSheet.Cells(k + 5, j).Borders.Weight = 2;//添加边框
     				}
				}
				var x=recordCount+6;
     			xls.Range("A"+x,"B"+x).MergeCells = true; 
     			xlSheet.Cells(x, 1).Value = "科室填报人："
     			xls.Range("C"+x,"H"+x).MergeCells = true;
     			xlSheet.Cells(x, 3).Value = "科室审核人："
				xlSheet.Columns.AutoFit;//单元格自适应大小
   				xls.ActiveWindow.Zoom = 100;//字体大小
   				xls.UserControl = true; // 很重要,不能省略,不然会出问题 意思是excel交由用户控制

	     xls.DisplayAlerts = false; 
	     xls.save();//选择路径保存
	     alert("导出成功！！！");                    
  		 xls.Quit();  
 		 xls = null;
 		 //按固定路径保存
 		 //xlSheet.SaveAs("C:\\Users\\Administrator.USER-20150630VQ\\Desktop\\Test.xls");
    	 xlBook.Close(savechanges=false);//关闭
    	 xlSheet.Application.Quit();//结束进程	
        });
        tmpAllStore.load(tmpParam); //获取所有数据
   		
    }
}
