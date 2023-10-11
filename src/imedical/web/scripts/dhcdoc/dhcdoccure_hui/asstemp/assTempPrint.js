var assTempPrint=(function(){
	function AssTemp_Print(DCAssRowId,MapDesc){
		if (DCAssRowId==""){
			$.messager.alert("��ʾ","δ������������������ܴ�ӡ��","warning");
			return;
		}
		var DCAssRowIdArr=DCAssRowId.split("^");
		var mylen=DCAssRowIdArr.length;
		for(var loop=0;loop<mylen;loop++){
			var DCAssRowId=DCAssRowIdArr[loop]
			var prtData=$.cm({
			    ClassName : "DHCDoc.DHCDocCure.Assessment",
			    MethodName : "GetAssPrintJson",
			    dataType:"text",
			    AssRowId:DCAssRowId
		    },false);
			
			if(prtData=="{}"){
				$.messager.alert("��ʾ","δ��ȡ��ӡ��Ϣ!","warning");
				return;
			}
			
			var prtJson=JSON.parse(prtData);
			prtJson.Para.Title=MapDesc;
			if(prtJson.Templet==""){
				$.messager.alert("��ʾ","δ��ȡ��xmlģ��!","warning");
				return;
			}
			//var preHtml=DHCSTXMLPrint_Preview.JsonToHtml(prtJson);
			var preObj=DHCXMLPrint_JsonToXml(prtJson);
			//alert(preObj.xmlPara)	
			var MyPara=preObj.xmlPara;
			var MyList=preObj.xmlList;
			var PrintTemplet=prtJson.Templet;
			var PrintTempletAry=PrintTemplet.split(",");
			for(var k=0;k<PrintTempletAry.length;k++){
				var Templet=PrintTempletAry[k];
			    DHCP_GetXMLConfig("InvPrintEncrypt",Templet);
			    var myobj=document.getElementById("ClsBillPrint");
			    //DHCP_PrintFunNew(myobj,MyPara,MyList);
			    DHC_PrintByLodop(getLodop(),MyPara,MyList,"","");
			}
		}	
	}

	/// Json��ʽ��Ϊxml��ӡ�ĸ�ʽ
	function DHCXMLPrint_JsonToXml(prtJson,preView){
		var para=prtJson.Para||"";
		var list=prtJson.List||[];
		var templet=prtJson.Templet||"";
		var morePara=prtJson.MorePara||"";
		var pageItms="";
		if (morePara!=""){
			pageItms=morePara.PageItms||"";
		}
		// Param
		var xmlPara="";
		for (var mId in para){
			var mIdData=para[mId]||"";
			var fLine=3;
			if((mId.indexOf("ConsTrePro")>-1)||(mId.indexOf("AssContent")>-1)){
				mIdData=mIdData.replace(String.fromCharCode(13),";")
				//mIdData=mIdData.replace(/\r\n/g,";/");
				//mIdData=mIdData.replace(/\n/g,";/");
				fLine=6;
				if(prtJson.Templet=="DHCCureAss_Print"){
					fLine=15;	
				}
			}
			mIdData=formatString(mIdData,fLine);
			if (xmlPara==""){
				xmlPara=mId+String.fromCharCode(2)+mIdData;
			}else{
				xmlPara+="^"+mId+String.fromCharCode(2)+mIdData;
			}
		}
		// List
		var xmlList="",xmlList1="";
		var listLen=list.length;
		for (var listI=0;listI<listLen;listI++){
			var listIData=list[listI];
			if (xmlList==""){
				xmlList=listIData
			}else{
				xmlList+=String.fromCharCode(2)+listIData
			}
		}
		return {
			xmlPara:xmlPara,
			xmlList:xmlList,
			xmlTemplet:templet,
			xmlList1:xmlList1
		}			
	}

	//��ʽ���ַ���,һ������̫�࣬���Զ�����
	//������fLine�趨������������ʡ�Ժ���ʾ fLineĬ��3��
	function formatString(Str,fLine){
		if((fLine=="")||(typeof fLine=="undefined")){
			fLine=3;
		}
		var fStr="";
		var Arr=Str.split("\n");
		var chklen=43;
		var gHeight=0;
		for(var i=0;i<Arr.length;i++){
			var mStr="";
			var aStr=Arr[i];
			var len=aStr.length;
			var loop=Math.ceil(len/chklen);
			for(var j=0;j<loop;j++){
				gHeight=gHeight+1;
				var s=aStr.slice(j*chklen,j*chklen+chklen)
				if(s=="")continue;
				if(mStr=="")mStr=s;
				else{mStr=mStr+"\n"+s}
			}
			if(gHeight>fLine){
				if(fStr=="")fStr=mStr;
				fStr=fStr+"\n"+"......"
				break;	
			}
			if(fStr=="")fStr=mStr;
			else{fStr=fStr+"\n"+mStr}
		}
		return fStr
	}

	function chkstrlen(str){
		var strlen=0;
		for(var i = 0;i < str.length; i++){
			if(str.charCodeAt(i) > 255) //����Ǻ��֣����ַ������ȼ�2
				strlen += 2;
			else  
				strlen++;
	����}
		return strlen;
	}
	
	return{
		"AssTemp_Print":AssTemp_Print	
	}
})()