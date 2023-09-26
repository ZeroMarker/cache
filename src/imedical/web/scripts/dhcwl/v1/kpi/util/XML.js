var XML=function(){
	
	function loadXML(xmlFile){
		var xmlDoc;
		try{
			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			if (xmlDoc) {  //for ie
		        xmlDoc.async="false";  
		        xmlDoc.load(xmlFile);			
			}
		    else if (document.implementation && document.implementation.createDocument){ 
				xmlDom= document.implementation.createDocument("","",null);
			}
		}catch(e){
			
			alert('暂不支持该浏览器载入XML！');
			return xmlDom;
		}
	    return (xmlDoc);
	}
	function getDirectChildren(parent){
		var eleNames=[];
		var childe=null;
		for(var i=0;i<parent.length;i++){
			childe=parent[i].firstChild;
			while(childe){
				eleNames.push(childe.nodeName);
				childe=childe.nextSibling;
			}
		}
		return eleNames;
	}
	function sendXml(xmlFile,serverURL,userFun,userScope){
		var xmlDoc=loadXML(xmlFile);
		if(!xmlDoc){
			alert(xmlFile+'文档加载失败！');
			return;
		}
		xmlHttp = new ActiveXObject ("Msxml2.XMLHTTP.3.0"); 
		var strDoc; 
		if (typeof(xmlDoc) == "object")//这里的判断是需要的.这里仍然需要加个xml后缀 
			strDoc = xmlDoc.xml; 
		else 
			strDoc = xmlDoc; 
		xmlHttp.open ("POST",serverURL,true); 
		//xmlHttp.onreadystatechange=callback(userFun); 
		xmlHttp.send(strDoc);
		function callback(userFun){
			if (xmlHttp.readyState==4) { 
				userFun.call(userScope, result.responseText);
			}
		}
	}
	function getValue(fromEle,eleName){
		var value="",isOk=false;
		return getValuePri(fromEle,eleName);
		
		function getValuePri(fromEle,eleName){
			if(isOk) return value;
			for(var i=0;i<fromEle.length;i++){
				if(fromEle[i].nodeType==1){
					var name=fromEle[i].nodeName;
					if(fromEle[i].nodeName==eleName){
						isOk=true;
						value=fromEle[i].firstChild.nodeValue;
					}
					if(isOk) return value;
					if(fromEle[i].childNodes.length > 0&&fromEle[i].firstChild.nodeType==1){
						getValuePri(fromEle[i].childNodes,eleName);
					}
				}
			}
			return value;
		}
		
	}
	function traverXMLToStr(path){
		var xmlDoc=loadXML(path);
		var xmlStr='<?xml version="1.0" encoding="GBK"?>';// <structDS>';
		var x = xmlDoc.documentElement;  //.childNodes;
		save(xmlStr);
		if(x&&x['length']){
			for (var i = 0; i < x.length; i++) {
				//xmlStr+=traverPri(x[i]);
				traverPri(x[i]);
			}
		}else if(x){
			traverPri(x);
		}
		//save("</structDS>");
		//return xmlStr+"</structDS>";
		function traverPri(ele){
			var str="";
			var tagName=ele.nodeName;
			if(ele.nodeType==1){
				var nodeValue=null,attValues="";
				if (ele.attributes){
					var atts=ele.attributes,att=null;
					for(var i=0;i<atts.length;i++){
						att=atts[i];
						if(attValues!=""){
							attValues+=' '+att.name+'="'+att.nodeValue+'"';
						}else{
							attValues=att.name+'="'+att.nodeValue+'"';
						}
					}
				}
				var children=ele.childNodes,temp,len=children.length;
				for(var i=0;i<len;i++){		
					if(i==0){
						//str+="<"+tagName+" "+attValues+">";
						save("<"+tagName+" "+attValues+">")
					}
					temp=traverPri(children[i]);
					if(temp){
						//str+=temp;
						save(temp);
					}
					if(i==len-1){
						//str+="</"+tagName+">";
						save("</"+tagName+">");
					}
				}
			}else if(ele.nodeType==3){
				return ele.nodeValue;
			}else if(ele.nodeType==4){
				return "<![CDATA["+ele.nodeValue+"]]>";
			}
			//return str;
		}
		function save(src){
			//add by wk.2016-2-15.
			//src=src.replace(/&/g,"&amp;");
			var srcLen=src.length,inde;
			for(var i=0;i<srcLen;i++){
				curentSize++;
				if(curentSize%stepSize==0) curentIndex++;
				XMLStrArr[curentIndex]=(XMLStrArr[curentIndex]||"")+src.charAt(i);
			}
		}
	}
	curentStep=0;
	curentSize=0;
	curentIndex=0;
	stepSize=0;
	XMLStrArr=[];
	this.stepTraverXML = function(path,size){
		stepSize=size;
		if(curentStep==0){
			close();
			stepSize=size;
			traverXMLToStr(path);
		}
		var result=XMLStrArr[curentStep++];
		if(!result) {
			curentStep=0;
			return null;
		}
		//alert(result);
		return result;
	}
	function close(){
		XMLStrArr=[];
		curentStep=0;
		stepSize=0;
		curentSize=0;
		curentIndex=0;
	}
}