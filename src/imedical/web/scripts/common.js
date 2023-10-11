/*
* @Author cryze 
* @Date 2018-4-20
* @Desc ͳһ?ƽ̨ ???Щ?js  ??????Ҳ???õ?
* @Modified 2018-4-23
*/

var common={};
common.setDataByRow=function(arr,row){
	if (!row) return false;
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			if (row[item] && $('#'+item).length>0 ) $('#'+item).val(row[item]);
		}else if(typeof item=="object"){
			if ($('#'+item.id).length==0 ) continue;
			if (item.type ){
				if ($.fn[item.type]) {
					if(item.type=="checkbox"){
						$('#'+item.id)[item.type]('setValue',row[item.id]==1);
					}else{
						if (item.multiple){
							var values=row[item.id].split(',');
							$('#'+item.id)[item.type]('setValues',values);
						}else{
							$('#'+item.id)[item.type]('setValue',row[item.id]);
						}
						
					}
					
				}else{
					$('#'+item.id).val(row[item.id]);
				}
			}else{
				$('#'+item.id).val(row[item.id]);
			}
			
		}
	}
}
common.getData=function(arr,prefix){
	var data={};
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			var key=item.substring((typeof prefix =="string"?prefix.length:0));
			if ($('#'+item).length>0 ) data[key]=$.trim($('#'+item).val());
		}else if(typeof item=="object"){
			if ($('#'+item.id).length==0 ) continue;
			var val="";
			if (item.type ){
				if ($.fn[item.type]){
					if(item.type=="checkbox"){
						val=$('#'+item.id)[item.type]('getValue')?1:0;
					}else{
						if (item.multiple){
							val=$('#'+item.id)[item.type]('getValues').join(',');
						}else{
							val=$('#'+item.id)[item.type]('getValue');
						}
						
					}
					
				}else{
					val=$.trim( $('#'+item.id).val() );
				}
			}else{
				val=$.trim( $('#'+item.id).val() );
			}
			if (item.fn) val=item.fn(val);
			var key=item.id.substring((typeof prefix =="string"?prefix.length:0));
			data[key]=val;
		}
	}
	return data;
}
common.clearData=function(arr){
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			if ($('#'+item).length>0 ) $('#'+item).val('');
		}else if(typeof item=="object"){
			if ($('#'+item.id).length==0 ) continue;
			if (item.type ){
				if ($.fn[item.type]) {
					if(item.type=="checkbox"){
						$('#'+item.id)[item.type]('setValue',true);
					}else{
						$('#'+item.id)[item.type]('setValue',"");
					}
					
				}else{
					$('#'+item.id).val("");
				}
			}else{
				$('#'+item.id).val("");
			}
			
		}
	}
}
common.disable=function(arr,except){
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			if (except && except.indexOf(item)>-1) continue;
			if ($('#'+item).length>0 ) $('#'+item).attr('disabled','disabled');
		}else if(typeof item=="object"){
			if ($('#'+item.id).length==0 ) continue;
			if (except && except.indexOf(item.id)>-1) continue;
			if (item.type ){
				if ($.fn[item.type]) {
					$('#'+item.id)[item.type]('disable');
					
				}else{
					$('#'+item.id).attr('disabled','disabled');
				}
			}else{
				$('#'+item.id).attr('disabled','disabled');
			}
			
		}
	}
}
common.enable=function(arr,except){
	for(var i=0,len=arr.length;i<len;i++){
		var item=arr[i];
		if (typeof item=="string"){
			if (except && except.indexOf(item)>-1) continue;
			if ($('#'+item).length>0 ) $('#'+item).removeAttr('disabled');
		}else if(typeof item=="object"){
			if ($('#'+item.id).length==0 ) continue;
			if (except && except.indexOf(item.id)>-1) continue;
			if (item.type ){
				if ($.fn[item.type]) {
					$('#'+item.id)[item.type]('enable');
				}else{
					$('#'+item.id).removeAttr('disabled');
				}
			}else{
				$('#'+item.id).removeAttr('disabled');
			}
			
		}
	}
}

///files ?????
///?????ж?ص?
///cfg {allSheet:true , callbackOnce:true} //allSheet ????sheet,Ĭ?ֻ?u?? callbackOnce???ص?Ĭ?һ??ļ???ɻص??
///fn ?ص?? ???????첽??
///fn (json){} name ??? json {"???":[[{},{},{}],[{},{},{}],[{},{},{}]], "???":[[{},{},{}],[{},{},{}],[{},{},{}]]} //ÿ??heet????? ??sheet?????ŵ?ͬһ??
///bug ???ת?Ĳ?????1940-4-1 ת???4/1/49  
//?1 ???4/1/49??????49ֻ?????949??2049? 
// ?2 ?ɽ?xlsx.core? e[14] = "m/d/yy"; ?? e[14] = "YYYY-MM-DD"; ??û???Ӱ??? 
common.transExcelData=function(files,cfg,fn){
	var wb,rABS = false;
	if (typeof cfg=="function") {
		fn=cfg;
		cfg={}
	}
	cfg = cfg || {};
	function setup_reader(file) {
	 var filename = file.name;
	 var reader = new FileReader();
	 ///?ΪIE????eadAsBinaryString???????дreadAsBinaryString??
	 if (!FileReader.prototype.readAsBinaryString) {
	     FileReader.prototype.readAsBinaryString = function (f) {
	         var binary = "";
	         var pt = this;
	         var reader = new FileReader();
	         reader.onload = function (e) {
	             var bytes = new Uint8Array(reader.result);
	             var length = bytes.byteLength;
	             for (var i = 0; i < length; i++) {
	                 binary += String.fromCharCode(bytes[i]);
	             }
	             pt.content = binary;
	             $(pt).trigger('onload');
	         };
	         reader.readAsArrayBuffer(f);
	     }
	 }

	 reader.onload = function (e) {
	     //alert("onload");
	     if (reader.result) reader.content = reader.result;
	     data = reader.content;
	     if (rABS) {
	         wb = XLSX.read(btoa(fixdata(data)), { //?ת?
	             type: 'base64'
	         });
	     } else {
	         wb = XLSX.read(data, {
	             type: 'binary'
	         });
	     }
	     var sheetArr=[];
	     if (cfg.allSheet){
		     for (var j=0,len=wb.SheetNames.length;j<len;j++){
			     var sheetItem=XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[j]]);
			     sheetArr.push(sheetItem);
			 }
		 }else{
			 var sheetItem=XLSX.utils.sheet_to_json(wb.Sheets[wb.SheetNames[0]]);
			 sheetArr.push(sheetItem);
		 }
		 if (cfg.callbackOnce){
			 AllJson[filename]=sheetArr;
			 completedCount++;
			 if (length==completedCount && typeof fn=="function") fn(AllJson);
		 }else{
			 if (typeof fn=="function"){
				 var json={};
				 json[filename]=sheetArr;
				 fn(json);
			 }
		 }

	    
	 };

	 if (rABS) {
	     reader.readAsArrayBuffer(file);
	 } else {
	     reader.readAsBinaryString(file);
	 }

	 function fixdata(data) { //???תBinaryString
	     var o = "",
	         l = 0,
	         w = 10240;
	     for (; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
	     o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
	     return o;
	 }
	}
	var AllJson={};
	var length=files.length,completedCount=0
	for(var i=0;i<length;i++){
		setup_reader(files[i]);
	}
}

common.isIE=function() { //ie?
	if (!!window.ActiveXObject || "ActiveXObject" in window)
		return true;
	else
		return false;
}

///2018-4-23 add 
///???lsx github
///?? Blob.js FileSaver.js
// columns ȡhisui-datagrid columns 
// cfg {sheetname:"sheet1",filename:"??",showHidden:false}  sheetname-sheet?? filename-?????  showHidden ??????
common.exportExcelByXLSX=(function(){
	
	function transrow(row,columns,ind,showHidden){
		var newrow={};
	    for (var i = 0; i < columns.length; i++) {
	        var cols = columns[i];
	        for (var j = 0; j < cols.length; j++) {
	            var col = cols[j];
	    
	            if ((col.hidden && ! showHidden )|| !col.field) {
	                continue;
	            }else{
		            var key=col.title||col.field;
	                if (typeof col.formatter=="function"){
	                    var content= col.formatter(row[col.field]||"",row,ind);
						newrow[key]=content;
	                }else{
	                    newrow[key]=row[col.field]||"";
	                }
	            }
	        }
	    }
	    return newrow;
	}
	return function(rows, columns,cfg){
		cfg=cfg||{};
		cfg.sheetname=cfg.sheetname || "sheet1";
		cfg.filename=cfg.filename || "??";
		cfg.showHidden=!!cfg.showHidden;
		var newrows=[];
		for (var i=0,len=rows.length;i<len;i++){
			newrows.push(transrow(rows[i],columns,i,cfg.showHidden))
		}
		var wb = XLSX.utils.book_new();
		var sheet=XLSX.utils.json_to_sheet(newrows);
		XLSX.utils.book_append_sheet(wb, sheet, cfg.sheetname);
		
		XLSX.writeFile(wb, cfg.filename+'.xlsx');

	}
})()
//exportExcelWithName ??Ҫ? ֱ???common.exportExcelByXLSX
common.exportExcelWithName=common.exportExcelByXLSX;