/**
 * @date 2022-01-22
 * @desc 改自平台组grid2excel.js 对 easyui-datagrid 和 extjs grid 导出为excel表格封装
 * @desc grid2excel(grid,cfg)
 * @other 对高级浏览器基于xlsx库，对于低版本IE基于MSExcel 
 * @用法：
 *	//1.导出导出所有页（IE11IsLowIE: false，IE11是否当作低版本IE处理,默认为 否， 可忽略）
 *	grid2excel($("#gridName"), {IE11IsLowIE: false,filename:'文件名',allPage: true});	
 *	//2.导出当前页
 *	grid2excel($("#gridName"), {filename:'文件名',allPage: false}});	
 *	//3.导出导出所有页并在完成后提示
 *	grid2excel($("#gridName"), {
 *		filename:'文件名',
 *		allPage: true,
 *		callback: function (success, data) {
 *			if (success) {
 *				$.messager.popover({msg: '导出成功'+ (data || ''),type:'success',timeout: 1000});
 *			} else {
 *				$.messager.popover({msg: '导出失败'+ (data || ''),type:'error',timeout: 1000});
 *			}
 *		}
 *	});	
 */
;(function(root){
    var $=root.jQuery;
    var Ext=root.Ext;
    function dynamicLoadJs(url, callback) {
        var head = document.getElementsByTagName('head')[0];
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = url;
        if(typeof(callback)=='function'){
            script.onload = script.onreadystatechange = function () {
                if (!this.readyState || this.readyState === "loaded" || this.readyState === "complete"){
                    if (callback ) callback();
                    script.onload = script.onreadystatechange = null;
                }
            };
        }
        head.appendChild(script);
    }
    var currentJsSrc, scripts = document.getElementsByTagName("script"); 
	currentJsSrc = scripts[scripts.length - 1].getAttribute("src");  //走到当前script 获取到的最后一个script标签刚好是此js
	var isLowIE=true;
	if (window.navigator.userAgent.indexOf("MSIE")==-1) {  //高级浏览器 加载xlsx.js
		isLowIE=false;
		var currentJsPathArr=currentJsSrc.split("/");
		currentJsPathArr.pop();
		var currentJsPath=currentJsPathArr.join("/");
		dynamicLoadJs(currentJsPath+'/Blob.js');
		dynamicLoadJs(currentJsPath+'/FileSaver.js');
		dynamicLoadJs(currentJsPath+'/xlsx.core.min.js');
    }

    ///ie下的文件路径选择
    function browseFolder(){  
        var ret="";
		try {  
			var Message = "请选择路径"; //选择框提示信息  
			var Shell = new ActiveXObject("Shell.Application");  
			var Folder = Shell.BrowseForFolder(0, Message, 0X0040, 0X11);//起始目录为：我的电脑  
			if (Folder != null) {  
				Folder = Folder.items(); // 返回 FolderItems 对象  
				Folder = Folder.item();  // 返回 Folderitem 对象  
				Folder = Folder.Path;    // 返回路径  
				if (Folder.charAt(Folder.length - 1) != "\\"){  
					Folder = Folder + "\\";  
				}
				ret= Folder;  
			}
		} catch(e) {  
			alert(e.message);  
        }
        return ret;
	}
    function excelExport(data,cfg){
        if(data && data.length>1) {
            var success=false;
            if(cfg.isLowIE) {
                success= msExcelExport('export',data,cfg.filefullname);
            }else{
                success= xlsxExcelExport(data,cfg.filefullname);
            }
            if(cfg.callback) cfg.callback(success,cfg.filefullname);
        }else{
            if(cfg.callback) cfg.callback(false,'未获取到数据');
        }

    }
    var msExcelExport=function(operation,data,filefullname){
        var success=true;
        //console.log(new Date());  //17
        var xlsApp = new ActiveXObject("Excel.Application");
        var xlsBook = xlsApp.Workbooks.Add();
        var xlsSheet = xlsBook.ActiveSheet;
        var range=xlsSheet.Range(xlsSheet.Cells(1,1), xlsSheet.Cells(data.length,data[0].length))
        range.Cells.Borders.Weight = 1;
        range.Cells.NumberFormatLocal="@";//将单元格的格式定义为文本  //经测试这样统一的修改比一个个cell修改快
        //console.log(new Date());  //18
        for (var i=0;i<data.length;i++){
            var row=data[i];
            for (var j=0;j<row.length;j++){
                var cell=xlsSheet.Cells(i+1,j+1);
                //cell.NumberFormatLocal="@";//将单元格的格式定义为文本   
                //cell.Borders.Weight = 1;
                cell.Value=row[j];
            }	
            //if(i%100==0) console.log(i);
        }
        range.Columns.AutoFit();
        //console.log(new Date());  //25
        if (operation=="export"){
            try{
                xlsBook.SaveAs(filefullname);
            }catch(e){
                success=false;
            }
        }else if(operation=="print"){
            xlsSheet.PageSetup.Zoom=false;
            xlsSheet.PageSetup.FitToPagesWide=1;
            xlsSheet.PageSetup.PaperSize = 8;  //A3
            xlsSheet.printout();
        }
        xlsBook.Close(savechanges=false);  //27
        //console.log(new Date());
        xlsSheet=null;
        xlsBook=null;
        xlsApp.Quit();
        xlsApp=null;
        return success;
        //console.log(new Date());  //27 
    };
    /*依赖 xlsx.core.min.js */
    var xlsxExcelExport=function(data,filefullname){
        var rows=[];
        for(var i=1;i<data.length;i++){
            var row={};
            var arr=data[i];
            for (var j=0;j<arr.length;j++){
                row[data[0][j]]=arr[j];
            }
            rows.push(row);
            
        }
        var wb = XLSX.utils.book_new();
        var sheet=XLSX.utils.json_to_sheet(rows);
        XLSX.utils.book_append_sheet(wb, sheet, 'sheet1');
        XLSX.writeFile(wb, filefullname); 
        return true; 
    };
    ///easyui datagrid 数据
    function getDatagridData(grid,cfg,onLoaded){
        var state=$.data(grid[0], "datagrid");
        var opts=state.options;
        cfg=cfg||{};
        if (cfg.allPage){
            var url=opts.url,queryParams=opts.queryParams;
            var autoParams={page:1,rows:1000000}; //datagrid自动加的参数
            if (opts.remoteSort && opts.sortName) {
                autoParams.sort=opts.sortName;
                autoParams.order=opts.sortOrder
            }
            if(url && url!=""){
                $.post(url,$.extend({},queryParams,autoParams),'','json').done(function(ret){
                    if (typeof ret.rows=="object" ) {
                        var data=formatDatagridData(ret.rows,opts.columns,cfg);
                        onLoaded(grid,cfg,data);
                    }
                })
            }else{
				//滚动加载表格导出方式改成适应前台分页查询的导出方式
                //var rows=state.data?( (opts.view.type=="scrollview"?state.data.firstRows:state.data.rows ) ||state.data||[]):[]; 			
				var rows=state.data?( (state.data.originalRows ? state.data.originalRows:state.data.rows ) ||state.data||[]):[];
                var data=formatDatagridData(rows,opts.columns,cfg);
                onLoaded(grid,cfg,data);
            }

        }else{
            var data=formatDatagridData(grid.datagrid('getRows'),opts.columns,cfg);
            onLoaded(grid,cfg,data);
        }
    }
    ///格式化easyui datagrid 数据
    function formatDatagridData(rows,columns,cfg){
        var data=[];
        var newrow=[];
        for (var i = 0; i < columns.length; i++) {
            var cols = columns[i];
            for (var j = 0; j < cols.length; j++) {
                var col = cols[j];			
                if ((col.hidden && ! cfg.showHidden )||(col.checkbox)||!col.field) {  //隐藏列及、复选框无标题列
                    continue;
                }else if ((col.field == 'expander')||(col.field == 'expander1')||(col.field == 'expander2')||(col.field == 'expander3')||(col.field == 'link')||(col.field == 'link1')||(col.field == 'link2')||(col.field == 'link3')||(col.field == 'ZY')) {  //链接
					continue;
				}else{
                    var key=col.title||col.field;
                    newrow.push(key);
                }
            }
        }
        data.push(newrow);

        for (var ind=0,rLen=rows.length;ind<rLen;ind++){
            var newrow=[],row=rows[ind];
            for (var i = 0; i < columns.length; i++) {
                var cols = columns[i];
                for (var j = 0; j < cols.length; j++) {
                    var col = cols[j];
                    if ((col.hidden && ! cfg.showHidden )||(col.checkbox) ||!col.field) {  //隐藏列及、复选框无标题列
						continue;
					}else if ((col.field == 'expander')||(col.field == 'expander1')||(col.field == 'expander2')||(col.field == 'expander3')||(col.field == 'link')||(col.field == 'link1')||(col.field == 'link2')||(col.field == 'link3')||(col.field == 'ZY')) {  //链接
						continue;
					}else{
                        var key=col.title||col.field;
                        if (typeof col.formatter=="function"){
                            var content=replaceHtml(col.formatter(row[col.field]||"",row,ind)||'') ;
                            //newrow[key]=content;
                            newrow.push(content);
                        }else{
                            //newrow[key]=row[col.field]||"";
                            newrow.push(row[col.field]||"");
                        }
                    }
                }
            }
            data.push(newrow);
        }
        return data;
    }
    ///将数据中的html代码去除
    var replaceHtml=function(str){
        return str.replace(/(<[^>]+>)|(&nbsp;)/ig,""); 
    }
    ///extjs load数据
    function getExtjsData(grid,cfg,onLoaded){
        if (cfg.allPage){
            var data=formatExtjsData(grid,grid.getStore(),cfg);
            onLoaded(grid,cfg,data);
        }else{
            var store=grid.getStore();
			var tProxy=new Ext.data.HttpProxy(new Ext.data.Connection({
				url : store.proxy.url
			}));
			var tStrore=new Ext.data.Store({
				proxy:tProxy,
				reader:store.reader
			})
			var params=Ext.apply({},store.lastOptions.params);
            params.start=0,params.limit=9999;
            tStrore.load({
				params:params,
				callback:function(r){
					var data=formatExtjsData(grid,tStrore,cfg);
					onLoaded(grid,cfg,data);
				}
			})
        }
    }
    ///格式化数据
    function formatExtjsData(grid,store,cfg){
		var data=[];
		var colCfg=grid.getColumnModel().config;
		var row=[];
		for (i=0;i<colCfg.length;i++){
			var col=colCfg[i];
			if(col.header=="" ||(col.hidden&&!cfg.showHidden)  || col.id=="checker") continue;
			row.push(col.header);
		}
		data.push(row);
		///直接取当前页的数据导出
        var storeItems=store.data.items;
        for (var j=0;j<storeItems.length;j++){
            var storeItem=storeItems[j];
            var row=[];
            for (i=0;i<colCfg.length;i++){
                var col=colCfg[i];
                if(col.header=="" || (col.hidden&&!cfg.showHidden) || col.id=="checker" ) continue;
                var val=storeItem.data[col.dataIndex]||"";
                if (col.renderer){  //renderer 只考虑value和record参数
                    val=replaceHtml( col.renderer(val,"",storeItem) ) ;
                }
                row.push( val.replace(/&#160;/ig,""));
            }
            data.push(row);
        }
		return data;
    }
    function isDatagrid(grid){
        if(root.jQuery && root.jQuery.ajax && grid instanceof root.jQuery && root.jQuery.data(grid[0],'datagrid')){
            return true;
        }else{
            return false;
        }
    }
    
    /**
     * 
     * @param {*} grid 表格  easyui 对应jq对象，extjs对应extjs组件
     * @param {*} cfg 
     * cfg.allPage是否所有页 默认否 
     * cfg.showhidden 是否显示隐藏列 默认否
     * cfg.filename 文件名
     * cfg.IE11IsLowIE IE11是否当作低版本IE处理  默认否  实际就是IE11是否要用MSExcel导出
     * 
     */
    function doExport(grid,cfg){
        cfg=cfg||{};
		cfg.isLowIE=false;
        if (!!window.ActiveXObject || "ActiveXObject" in window) {
			if (window.navigator.userAgent.indexOf("MSIE")>-1) {
				cfg.isLowIE=true;
			}else{
				if (cfg.IE11IsLowIE ) cfg.isLowIE=true;
			}
		}
        

		if (cfg.isLowIE){
            var path=browseFolder();
            if (typeof path=="string" && path.length>0 && path.indexOf('\\')>-1 && path.split(':').length==2){
                var filefullname=path+cfg.filename;
            }else{
                if (cfg.callback) cfg.callback(false,'请选择正确的路径');
                return ;
            }
			
			
		}else{
			var filefullname=cfg.filename+".xlsx";
		}
        cfg.filefullname=filefullname;

        if (isDatagrid(grid)){ //如果是easyui datagrid
            getDatagridData(grid,cfg,function(grid,cfg,data){
                excelExport(data,cfg);
            })
        }else{
            getExtjsData(grid,cfg,function(grid,cfg,data){
                excelExport(data,cfg);
            })
        }
    }
    root.grid2excel=doExport;
})(window);


