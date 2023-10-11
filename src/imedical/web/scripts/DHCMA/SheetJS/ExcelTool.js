var isIE = window.ActiveXObject || "ActiveXObject" in window; //IE浏览器

//转二进制
function fixdata(data) {
    var o = "",
        l = 0,
        w = 10240;
    for(; l < data.byteLength / w; ++l) o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w, l * w + w)));
    o += String.fromCharCode.apply(null, new Uint8Array(data.slice(l * w)));
    return o;
}

//读取文件，获取工作簿，返回workbook对象
function getWorkBook(file,callback){
	var reader = new FileReader();
    reader.onload = function(e) {
        var data = e.target.result;
        var wb="";
        if(!isIE){
        	if(data.indexOf("<Author>DHCMA.CPW</Author>")>0){
        		data=decodeURIComponent(escape(data))
        	}
        	wb = XLSX.read(data,{
                type: 'binary'
           	 });
        	
        }else{
	        data=fixdata(data);
	        if(data.indexOf("<Author>DHCMA.CPW</Author>")>0){
        		data=decodeURIComponent(escape(data))
        			wb = XLSX.read(data,{
                	type: 'binary'
           	 	});
        	}else{
        	 	wb = XLSX.read(btoa(data),{
                	type: 'base64'
            	});
        	}
        }
        return callback(wb,file.name)
    };
    if(isIE) {
        reader.readAsArrayBuffer(file);
    } else {
        reader.readAsBinaryString(file);
    }
}
