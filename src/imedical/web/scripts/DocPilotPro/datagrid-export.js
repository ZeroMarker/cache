///无需导出的列 可以通过在页面对应js中定义PageLogicObj.NotShowListStr 以^分割 例如："^列title1^列title2^"
/*var PageLogicObj={
	NotShowColTitleStr:"^不显示列title1^不显示列title2^" 
	,ShowColTitleStr:"^显示列title1^显示列title2^"
	//通过indexOf判断不需要显示的列 title用^分割	
}*/
(function($){
    function getRows(target){
        var state = $(target).data('datagrid');
        if (state.filterSource){
            return state.filterSource.rows;
        } else {
			//return state.data.rows;
			return state.data.originalRows||state.originalRows;	
        }
    }
    function toHtml(target, rows){
        rows = rows || getRows(target);
		
		var arrayCol = new Array();  //无需导出的数据列
        var dg = $(target);
        var data = ['<table border="1" rull="all" style="border-collapse:collapse">'];
        var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
		
        var trStyle = 'height:32px';
        var tdStyle0 = 'vertical-align:middle;padding:0 4px';
        data.push('<tr style="'+trStyle+'">');
        for(var i=0; i<fields.length; i++){
            var col = dg.datagrid('getColumnOption', fields[i]);
           			
			if(col.hidden == true) {   //隐藏列
				arrayCol[arrayCol.length] = i;
				continue;
			}
			if(col.checkbox == true) {  //复选框
				arrayCol[arrayCol.length] = i;
				continue;
			}
		
			if ((col.field == 'expander')||(col.field == 'link')||(col.field.indexOf('link')>=0)||(col.field.indexOf('expander')>=0)) {  //链接
				arrayCol[arrayCol.length] = i;
				continue;
			}	
			if(!col.title) {  //无标题
				arrayCol[arrayCol.length] = i;
				continue;
			}			
            if(col.title=="操作") {  //操作列不显示
				arrayCol[arrayCol.length] = i;
				continue;
			}	
            //通过indexOf判断不需要显示的列 ^分割
            var CelltitleStr="^"+col.title+"^"
            if ((typeof PageLogicObj.NotShowColTitleStr!= "undefined")&&(PageLogicObj.NotShowColTitleStr!="")&&(PageLogicObj.NotShowColTitleStr.indexOf(CelltitleStr)>=0)){
                arrayCol[arrayCol.length] = i;
				continue;
            }
            if ((typeof PageLogicObj.ShowColTitleStr!= "undefined")&&(PageLogicObj.ShowColTitleStr!="")&&(PageLogicObj.ShowColTitleStr.indexOf(CelltitleStr)<0)){
                arrayCol[arrayCol.length] = i;
				continue;
            }	
            var tdStyle = tdStyle0 + ';width:'+(col.boxWidth+50)+'px;';
            data.push('<th style="'+tdStyle+'">'+col.title+'</th>');
        }
        data.push('</tr>');
		
        $.map(rows, function(row){
            data.push('<tr style="'+trStyle+'">');
            for(var i=0; i<fields.length; i++){
				var index = $.inArray(i,arrayCol);
				if(index >= 0){
					continue;
				}
				var field = fields[i];
				if (field.indexOf("|")<0) {
					var value = row[field];
				}else {
					var value=row[field.split("|")[0]]+String.fromCharCode(1)+ "/"+String.fromCharCode(1)+row[field.split("|")[1]];					
				}
			    
				var tdStyle1 ="";
				if ((value)&&(!isNaN(value))) { //判断字符串是否为纯数字
				  	tdStyle1 =";mso-number-format:'\@'";  //解决纯数字列导出没有0或变成科学style="mso-number-format:'\@';"   
				} 
                data.push(
                    '<td style="'+tdStyle0+tdStyle1+'">'+value+'</td>'
                );
            }
            data.push('</tr>');
        });
        data.push('</table>');
		
        return data.join('');
    }

    function toArray(target, rows){
        rows = rows || getRows(target);
        var dg = $(target);
        var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
        var data = [];
        var r = [];
        var arrayCol = new Array();  //无需导出的数据列
        for(var i=0; i<fields.length; i++){
            var col = dg.datagrid('getColumnOption', fields[i]);
            if(col.hidden == true) {   //隐藏列
				arrayCol[arrayCol.length] = i;
				continue;
			}
			if(col.checkbox == true) {  //复选框
				arrayCol[arrayCol.length] = i;
				continue;
			}
		
			if ((col.field == 'expander')||(col.field == 'link')||(col.field.indexOf('link')>=0)||(col.field.indexOf('expander')>=0)) {  //链接
				arrayCol[arrayCol.length] = i;
				continue;
			}	
			if(!col.title) {  //无标题
				arrayCol[arrayCol.length] = i;
				continue;
			}			
            //通过indexOf判断不需要显示的列 ^分割
            var CelltitleStr="^"+col.title+"^"
            if ((typeof PageLogicObj.NotShowColTitleStr!= "undefined")&&(PageLogicObj.NotShowColTitleStr!="")&&(PageLogicObj.NotShowColTitleStr.indexOf(CelltitleStr)>=0)){
                arrayCol[arrayCol.length] = i;
				continue;
            }
            if ((typeof PageLogicObj.ShowColTitleStr!= "undefined")&&(PageLogicObj.ShowColTitleStr!="")&&(PageLogicObj.ShowColTitleStr.indexOf(CelltitleStr)<0)){
                arrayCol[arrayCol.length] = i;
				continue;
            }	
            r.push(col.title);
        }
        data.push(r);
        $.map(rows, function(row){
            var r = [];
            for(var i=0; i<fields.length; i++){
	            var index = $.inArray(i,arrayCol);
				if(index >= 0){
					continue;
				}
                r.push(row[fields[i]]);
            }
            data.push(r);
        });
        return data;
    }

    function print(target, param){
        var title = null;
        var rows = null;
        if (typeof param == 'string'){
            title = param;
        } else {
            title = param['title'];
            rows = param['rows'];
        }
	//常用1440*900
        var newWindow = window.open('', '', 'width=1920, height=890');
        var document = newWindow.document.open();
        var content = 
            '<!doctype html>' +
            '<html>' +
            '<head>' +
            '<meta charset="utf-8">' +
            '<title></title>' +
            '</head>' +
            '<body>' +'<h1 style="text-align: center;">'+title+'</h1>'
            + toHtml(target, rows) + '</body>' +
            '</html>';
        document.write(content);
        document.close();
        newWindow.print();
		///打印完直接关闭
		setTimeout(function(){
			newWindow.close()
		},300);
    }

    function b64toBlob(data){
        var sliceSize = 512;
        var chars = atob(data);
        var byteArrays = [];
        for(var offset=0; offset<chars.length; offset+=sliceSize){
            var slice = chars.slice(offset, offset+sliceSize);
            var byteNumbers = new Array(slice.length);
            for(var i=0; i<slice.length; i++){
                byteNumbers[i] = slice.charCodeAt(i);
            }
            var byteArray = new Uint8Array(byteNumbers);
            byteArrays.push(byteArray);
        }
        return new Blob(byteArrays, {
            type: ''
        });
    }
    
	function isIE11() {
	  var re = /rv:11.0/g
	  return re.test(navigator.userAgent.toLowerCase());
	}
    function toExcel(target, param){
        var filename = null;
        var rows = null;
        var worksheet = 'Worksheet';
        if (typeof param == 'string'){
            filename = param;
        } else {
            filename = param['filename'];
            rows = param['rows'];
            worksheet = param['worksheet'] || 'Worksheet';
        }
		
			    
	        var dg = $(target);
	        var uri = 'data:application/vnd.ms-excel;base64,'
	        , template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><meta http-equiv="content-type" content="application/vnd.ms-excel; charset=UTF-8"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body>{table}</body></html>'
	        , base64 = function (s) { return window.btoa(unescape(encodeURIComponent(s))) }
	        , format = function (s, c) { return s.replace(/{(\w+)}/g, function (m, p) { return c[p]; }) }
	       
	        var table = toHtml(target, rows);
	        var ctx = { worksheet: worksheet, table: table };
	        var data = base64(format(template, ctx));
			
	        if (window.navigator.msSaveBlob){
	            var blob = b64toBlob(data);
	            window.navigator.msSaveBlob(blob, filename);
	        } else {
	            var alink = $('<a style="display:none"></a>').appendTo('body');
	            alink[0].href = uri + data;
	            alink[0].download = filename;
	            alink[0].click();
	            alink.remove();
	    }
    }

    $.extend($.fn.datagrid.methods, {
        toHtml: function(jq, rows){
            return toHtml(jq[0], rows);
        },
        toArray: function(jq, rows){
            return toArray(jq[0], rows);
        },
        toExcel: function(jq, param){
            return jq.each(function(){
                toExcel(this, param);
            });
        },
        print: function(jq, param){
            return jq.each(function(){
                print(this, param);
            });
        }
    });
    function Cleanup(){
		window.clearInterval(idTmr);
		CollectGarbage();
	}
  	function toSheet(target, rows,filename){   //IE11以下版本使用原先导出方式
        rows = rows || getRows(target);
        var dg = $(target);
        var arrayCol = new Array();  //无需导出的数据列
        
        try {
			xls = new ActiveXObject("Excel.Application");
		}catch (e) {
			xls =null;
			$.messager.alert("提示","创建Excel应用对象失败!\n\n如果您确信您的电脑中已经安装了Excel，"+"那么请调整IE的安全级别。\n\n具体操作：\n\n"+"工具 → Internet选项 → 安全 → 自定义级别 → 对没有标记为安全的ActiveX进行初始化和脚本运行 → 启用",'info');
			return null;
		}
		xls.Visible = false;
		xlBook = xls.Workbooks.Add();
		xlSheet=xlBook.Worksheets(1);
		
        var fields = dg.datagrid('getColumnFields',true).concat(dg.datagrid('getColumnFields',false));
        for(var i=0,indc =0;i<fields.length; i++){
            var col = dg.datagrid('getColumnOption', fields[i]);
			if(col.hidden == true) {   //隐藏列
				arrayCol[arrayCol.length] = i;
				continue;
			}
			if(col.checkbox == true) {  //复选框
				arrayCol[arrayCol.length] = i;
				continue;
			}
		
			if ((col.field == 'expander')||(col.field == 'link')||(col.field.indexOf('link')>=0)||(col.field.indexOf('expander')>=0)) {  //链接
				arrayCol[arrayCol.length] = i;
				continue;
			}	
			if(!col.title) {  //无标题
				arrayCol[arrayCol.length] = i;
				continue;
			}			
            //通过indexOf判断不需要显示的列 ^分割
            var CelltitleStr="^"+col.title+"^"
            if ((typeof PageLogicObj.NotShowColTitleStr!= "undefined")&&(PageLogicObj.NotShowColTitleStr!="")&&(PageLogicObj.NotShowColTitleStr.indexOf(CelltitleStr)>=0)){
                arrayCol[arrayCol.length] = i;
				continue;
            }
            if ((typeof PageLogicObj.ShowColTitleStr!= "undefined")&&(PageLogicObj.ShowColTitleStr!="")&&(PageLogicObj.ShowColTitleStr.indexOf(CelltitleStr)<0)){
                arrayCol[arrayCol.length] = i;
				continue;
            }	
            indc ++;
            xlSheet.Cells(1, indc).value = col.title;
        }
   
        for (var i = 0; i <rows.length; i++) {
            for(var j=0,indr=0; j<fields.length; j++){               
                var index = $.inArray(j,arrayCol);
				if(index >= 0){
					continue;
				}
				indr ++;
				var fieldvalue = rows[i][fields[j]];
				if (fieldvalue!=null) { 
					xlSheet.Cells(i + 2, indr).NumberFormatLocal = "@";
					xlSheet.Cells(i + 2, indr).value = fieldvalue.toString();  
				}else {
					xlSheet.Cells(i + 2, indr).value = "";  
				}
            }
        }
        
        xlSheet.Cells.EntireColumn.AutoFit;  //列宽自适应
        
        if (filename){
			filename = filename;
		} else {
			filename = "*.xls";
		}
		var fname = xls.Application.GetSaveAsFilename(filename, "Excel Spreadsheets (*.xls), *.xls");
		if (fname != false){
			//目录中存在重名的文件，在打开调试时选择“否”、“取消”会有报错
			//不知对选择“否”的处理如何写，暂时不处理
			try {
				xlBook.SaveAs(fname);
			}catch(e){
				//alert(e.message);
				return false;
			}
		}
		xlSheet=null;
		xlBook.Close (savechanges=false);
		xls.Quit();
		xlSheet=null;
		xlBook=null;
		xls=null;
		idTmr=window.setInterval("Cleanup();",1);
		
		return true;
 	 }
    
})(jQuery);
