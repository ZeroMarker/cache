/*
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
            delete (tmpParam.params[tmpStore.paramNames.start]); //删除分页参数
            delete (tmpParam.params[tmpStore.paramNames.limit]);
             //tmpParam.params[tmpStore.paramNames.start]=0; 
            //tmpParam.params[tmpStore.paramNames.limit]=1000;
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
   		for (i = 2; i < colCount; i++) {
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
		xlSheet.Cells(1, 1).Value ="项 目 预 算 明 细 表";
		xlSheet.Cells(1, 1).Font.Name = "宋体"; 
		xlSheet.Cells(1, 1).Font.Bold = true; 
		xlSheet.Cells(1, 1).Font.Size = 15;
		xlSheet.Cells(1,1).HorizontalAlignment = 3; 
		xls.Range("A2:L2").MergeCells = true;
		xlSheet.Cells(2, 1).Value ="预算年度："+yearField.getValue()+" 年";
		xlSheet.Cells(2,1).HorizontalAlignment = 3;
		xlSheet.Cells(3, 1).Value = "编制单位："
		xlSheet.Cells(3, 2).Value = "科室负责人："
		xlSheet.Cells(3, 3).Value = "主管领导："
		xls.Range("C3:E3").MergeCells = true;
		xlSheet.Cells(3, 6).Value = "提交时间："
		xls.Range("F3:I3").MergeCells = true;
   	/*    xlSheet.Cells(4, 1).Value ="资金类别";
   	    xlSheet.Cells(4,1).HorizontalAlignment = 3; //控制单元格居中
   	    xlSheet.Cells(4, 2).Value ="项目名称";
   	    xlSheet.Cells(4,2).HorizontalAlignment = 3;	    
   	    xlSheet.Cells(4, 3).Value ="预算项名称";
   	    xlSheet.Cells(4,3).HorizontalAlignment = 3;    	   
   	    xlSheet.Cells(4, 4).Value ="预算科室";
   	    xlSheet.Cells(4,4).HorizontalAlignment = 3;
   	    xlSheet.Cells(4, 5).Value ="预算单价";
   	    xlSheet.Cells(4,5).HorizontalAlignment = 3; 
   	    xlSheet.Cells(4, 6).Value ="预算数量";
   	    xlSheet.Cells(4,6).HorizontalAlignment = 3; 
	   xlSheet.Cells(4, 7).Value ="预算总占比(%)";
   	    xlSheet.Cells(4,7).HorizontalAlignment = 3; 	
	   xlSheet.Cells(4, 8).Value ="预算金额";
   	    xlSheet.Cells(4,8).HorizontalAlignment = 3; 	
		   xlSheet.Cells(4, 9).Value ="设备名称备注";
   	    xlSheet.Cells(4,9).HorizontalAlignment = 3; 	
		   xlSheet.Cells(4, 10).Value ="新增/更新";
   	    xlSheet.Cells(4,10).HorizontalAlignment = 3; 	
			   xlSheet.Cells(4, 11).Value ="人员资质-原有设备";
   	    xlSheet.Cells(4,11).HorizontalAlignment = 3; 
		   xlSheet.Cells(4, 12).Value ="收费标准";
   	    xlSheet.Cells(4,12).HorizontalAlignment = 3; 	
	   xlSheet.Cells(4, 13).Value ="年效益预测";
   	    xlSheet.Cells(4,13).HorizontalAlignment = 3; 
	   xlSheet.Cells(4, 14).Value ="耗材费";
   	    xlSheet.Cells(4,14).HorizontalAlignment = 3; 		
		xlSheet.Cells(4, 15).Value ="配套条件";
   	    xlSheet.Cells(4,15).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 16).Value ="备注";
   	    xlSheet.Cells(4,16).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 17).Value ="推荐品牌1";
   	    xlSheet.Cells(4,17).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 18).Value ="规格型号1";
   	    xlSheet.Cells(4,18).HorizontalAlignment = 3; 
			xlSheet.Cells(4, 19).Value ="推荐品牌2";
   	    xlSheet.Cells(4,19).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 20).Value ="规格型号2";
   	    xlSheet.Cells(4,20).HorizontalAlignment = 3; 
			xlSheet.Cells(4, 21).Value ="推荐品牌3";
   	    xlSheet.Cells(4,21).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 22).Value ="规格型号3";
   	    xlSheet.Cells(4,22).HorizontalAlignment = 3; 
			xlSheet.Cells(4, 23).Value ="责任科室";
   	    xlSheet.Cells(4,23).HorizontalAlignment = 3; 	
		xlSheet.Cells(4, 24).Value ="状态";
   	    xlSheet.Cells(4,24).HorizontalAlignment = 3; */
		
   	/*	for (l = 2; l <= temp_obj.length+1; l++) {
    			xlSheet.Cells(4, l-1).Value = cm.getColumnHeader(temp_obj[l-2]); 
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
     				// EXCEL数据从第二行开始,故row = k + 1
						
			    //tempstr=view.getCell(k - 1, temp_obj[0]).innerText;
				//alert(view.getCell(k - 1, temp_obj[j-1]).innerText)
				xlSheet.Cells(k + 4, j).Value = view.getCell(k - 1, temp_obj[j-1]).innerText;
     				xlSheet.Cells(k + 4, j).Borders.Weight = 2;//添加边框
     				}
				}
				var x=recordCount+5;
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
	//退出操作excel的实例对象
	xls.Application.Quit();
	//手动调用垃圾收集器
	CollectGarbage();	 
        });
        tmpAllStore.load(tmpParam); //获取所有数据
   		
    }
}*/

/** 分页导出所有Execl导出方法 **/
function ExportAllToExcel(gridPanel,name) {
	if(typeof gridPanel === 'string'){
		gridPanel = Ext.getCmp(gridPanel);
	}
	if (gridPanel) {
		var tmpStore = gridPanel.getStore();
		//以下处理分页grid数据导出的问题，从服务器中获取所有数据，需要考虑性能
		var tmpParam = tmpStore.lastOptions //此处克隆了原网格数据源的参数信息
		if (tmpParam && tmpParam.params) {
			tmpParam.params[tmpStore.paramNames.start]=0;
			tmpParam.params[tmpStore.paramNames.limit]=999999; //重置分页信息
		}else{
			Ext.Msg.show({title:'注意',msg:'没有需要导出的数据！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			//Msg.info('warning','没有需要导出的数据！');
			return false;
		}
		var tmpAllStore = new Ext.data.Store({	//重新定义一个数据源
			proxy: tmpStore.proxy,
			reader: tmpStore.reader
		});
		tmpAllStore.on('load', function (store) {
			if(!name){
				//grid--title添加button后的特殊处理
				var gridPanelTitle = Ext.isEmpty(gridPanel.title)? '' : gridPanel.title.split('&nbsp')[0];
				name = gridPanelTitle + new Date().format('Y-m-d-His');
			}
			if(document.all.ExportExcel == null || document.all.ExportExcel.object == null){
				StoreSaveAsExcel.defer(10,this,[store,gridPanel.getColumnModel(),name]);
			}else{
				StoreSaveAsExcelByOwc.defer(10,this,[store,gridPanel.getColumnModel(),name]);
			}
		});
		//获取所有数据
		tmpAllStore.load({
			params : tmpParam.params,
			callback : function(r,options,success){
				if(!success){
					Ext.Msg.show({title:'注意',msg:'数据加载错误!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
					//Msg.info('error', '数据加载错误!');
				}
			}
		});
	}
};

function SetFieldOriginal(field){
	if(field.items!=null){
		field.items.each(function(subField){
			SetFieldOriginal(subField);
		});
	}else{
		field.originalValue=String(field.getValue());
	}
}


function StoreSaveAsExcel(store,cm,name)
{
	if (store.getCount()==0)
	{
		Ext.Msg.show({title:'注意',msg:'没有需要导出的数据！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		//Msg.info('warning','没有需要导出的数据！');
		return;
	}
	var fd = new ActiveXObject("MSComDlg.CommonDialog");
	fd.Filter = "Microsoft Office Excel(*.xls)|*.xls";
	fd.FilterIndex = 1;
	fd.FileName=name
	// 必须设置MaxFileSize. 否则出错
	fd.MaxFileSize = 32767;
	// 显示对话框
	fd.ShowSave();
	var fileName=fd.FileName;
	if (fd.Flags == 0 || fileName==''){
		return;
	}
	//
	try
	{
		var xlApp=new ActiveXObject("Excel.Application");
	}
	catch (e)
	{
		//Msg.info("warning","必须安装excel，同时浏览器允许执行ActiveX控件");
		Ext.Msg.show({title:'注意',msg:'必须安装excel，同时浏览器允许执行ActiveX控件!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		return "";
	}
	
	var fso = new ActiveXObject("Scripting.FileSystemObject");
	if(fso.FileExists(fileName)){
		var fileArr=fileName.split("\\");
		var fileDesc=fileArr[fileArr.length-1];
		if(confirm('文件"'+fileDesc+'"已经存在，是否替换原有文件？')==false){
			xlApp.Quit();
			xlApp=null;
			return;
		}
	}
	
	xlApp.Visible=false;
	xlApp.DisplayAlerts = false;
	var xlBook=xlApp.Workbooks.Add();
	var xlSheet=xlBook.Worksheets(1);	
	
	var colCount=cm.getColumnCount();
	var temp_obj=[];	//存放需要导出的columns
	var arr_obj=[];		//存放原始record所有name
	
	var temp_obj=cm.getColumnsBy(function(c){
		return !(c.hidden || c.dataIndex=="" || c.IFExport===false);
	});
	
	//Excel第一行存放标题
	for (var n=0;n<temp_obj.length;n++){
		xlSheet.Cells(1,n+1).Value=temp_obj[n].header;
	}
	
	var recordCount=store.getCount();
	for (var k=0;k<recordCount;k++){
		var arrRecord=store.getAt(k);
		for (var j=0, colLen = temp_obj.length; j<colLen; j++){
			var colDataIndex=temp_obj[j].dataIndex;
			var colRenderer = temp_obj[j].renderer;
			var cellValue=arrRecord.get(colDataIndex);
			//column定义中, useRenderExport : false, 则在导出时不使用该column的renderer
			if(colRenderer.toString().replace(/\s/g,'')!="function(value){returnvalue;}"
			&& temp_obj[j].xtype!="checkcolumn" && temp_obj[j].useRenderExport!==false){
				var cellValue = temp_obj[j].renderer(cellValue,{},arrRecord,k,j,store);
			}
			cellValue = Ext.util.Format.stripTags(cellValue);
			var regExpPattern=/^(-?\d*)(.?\d*)$/;
			if(cellValue!="" && regExpPattern.test(cellValue)){
				xlSheet.Cells(k+2,j+1).Value="\'"+cellValue;	//全数字转换成字符串
			}else{
				xlSheet.Cells(k+2,j+1).Value=cellValue;
			}
		}
	}
	
	try{
		var ss = xlBook.SaveAs(fileName);  
		if (ss==false)
		{
			Ext.Msg.show({title:'注意',msg:'另存失败！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			//Msg.info('error','另存失败！') ;
		}else{
			Ext.Msg.show({title:'注意',msg:'Excel导出成功!',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
			//Msg.info('success', 'Excel导出成功!');
		}
	}
	catch(e){
		Ext.Msg.show({title:'注意',msg:'另存失败！',buttons: Ext.Msg.OK,icon:Ext.MessageBox.WARNING});
		//Msg.info('error','另存失败！') ;
	}

	xlApp.Quit();
	xlApp=null;
	xlBook=null;
	xlSheet=null;
}
