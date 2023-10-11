/**
	zhouxin
	2019-07-03
*/
var pageSize=3;
$(function(){
	//initCrumbs(); //���Ӳ�Ҫ��ע�͵�
	initDataGrid(1);
	initPage();
})

function initCrumbs(){
	var input=$("#input").val();
	inputNew=input.replace(/[%]/g,"%25") 				//�����ַ����� kml 2020-03-02
	var inputType=$("#inputType").val();
	crumbHtml="<a href='javascript:void(0);' onclick='goCrumbList(\""+inputNew+"\",\""+inputType+"\")' >" +input+"</a>";
	$("#tableTb").html(crumbHtml);
}

function initDataGrid(pageNo){
	runClassMethod(
		"web.DHCCKKBIndex",
		"List",
		{
			page:pageNo,
			rows:pageSize,
			queryPar:$("#input").val(),
			queryType:$("#inputType").val(),
			drugOther:$("#drugOther").val(), //kml
			userInfo:userInfo,
			version:$("#version").val(),	// qnp 2021/5/19 ���Ӱ汾
			drugType:$("#drugType").val(),	// qnp 2021/6/24 ��������
			promptStr:decodeURI(decodeURI($("#ParStr").val())),      //xww 2021-08-11 ���Ӹ߼���ѯ����
			gennamedr:$("#gennamedr").val()
		},function(data){
			if(data.total ==0){
				
				parent.closeTab($("#input").val())
				
				return
			}
	
			if((data.total ==1)&&(data.rows[0].GenerName!="LiterSupData")&&(data.rows[0].GenerName)){
				var input=$("#input").val();
				var inputType=$("#inputType").val();
				window.location.href="dhcckb.wiki.csp?IncId="+data.rows[0].id+"&catId=&input="+input+"&inputType="+inputType
				addClickTimes(data.rows[0].id,Loginfo)
				return
			}
			var html=""
			
			$.each(data.rows,function(index,obj){
				html+=rowTemplate(obj)
			})
			//console.log(html)
			$("#datagrid").html(html);
			
			var totalPage=Math.ceil(data.total/pageSize) //kml 2020-05-11����ȡ��
			$("#pagination").pagination("setPage", pageNo, totalPage);
			window.parent.resize();	
		},
		"json"
	)
}

function rowTemplate(rowData){
	var input=$("#input").val();
	var inputType=$("#inputType").val();
	var rowHtml="";
	rowHtml+="<div class='datagridRow'>";
	if(rowData.id!=undefined){ //kml	 
	 var incDesc="";
	 var incSpec="";
	 var incPackage="";
	 var incManf="";
	 var Indication="";
	 var Contraindication="";
	 var Ingredient="";
	 var GenerName ="";
	 var releaseDate="";
	 var origin="";
	 var incDesc="";
	 var url=""
	 var shortDesc="";
		var indication=""
	 if(rowData.url!="")
	 {
	  url=rowData.url;	 
	 }
		rowHtml+="<div class='rowTitle'><a href='#' onclick='goCrumbWiki("+rowData.id+",\"\",\""+input+"\",\""+inputType+"\",\""+Loginfo+"\",\""+url+"\")'>"+rowData.incDesc+"</a></div>";
		rowHtml+="<div class='rowData' >";
		if(rowData.incSpec!=""){
			  incSpec=rowData.incSpec;
		}
		if(rowData.incPackage!=""){
			  incPackage=rowData.incPackage;
		}
		if(rowData.incManf!=""){
			  incManf=rowData.incManf;
		}
		if(rowData.Indication!=""){
			  Indication=rowData.Indication;
		}
		if(rowData.Contraindication!=""){
			  Contraindication=rowData.Contraindication;
		}
		if(rowData.Ingredient!=""){
			  Ingredient=rowData.Ingredient;
		}
		if(rowData.GenerName!=""){
			  GenerName=rowData.GenerName;
		}
			if(rowData.incDesc!=""){
			  incDesc=rowData.incDesc;
		}
			if(rowData.origin!=""){
			  origin=rowData.origin;
		}
		if(rowData.releaseDate!=""){
			  releaseDate=rowData.releaseDate;
		}
		if(rowData.indication!=""){
			  indication=rowData.indication;
		}
		if(rowData.shortDesc!=""){
			  shortDesc=rowData.shortDesc;
		}

		if((rowData.GenerName=="DrugData")||(rowData.GenerName=="ChineseDrugData")){
			rowHtml+="<span style='width:250px;'><b>ͨ������</b>"+incSpec+"</span>";
			rowHtml+="<span style='width:250px;'><b>��Ʒ����</b>"+incPackage+"</span>";
			rowHtml+="<span style='width:250px;'><b>���Գɷݣ�</b>"+incManf+"</span>"
			rowHtml+="<span style='width:250px;'><b>���</b>"+Indication+"</span><br>";
			rowHtml+="<span><b>��Ӧ֢��</b>"+Contraindication+"</span><br>";
			//rowHtml+="<span><b>����֢��</b>"+indication+"</span><br>";

			rowHtml+="<span><b>������ҵ��</b>"+Ingredient+"</span><br>";
		}else if(rowData.GenerName=="ChineseHerbalMedicineData"){ //yuliping ��ҩ��Ƭ
			rowHtml+="<span style='width:250px;'><b>��Ƭ���ƣ�</b>"+incSpec+"</span>";
			rowHtml+="<span style='width:250px;'><b>����Ӧ����</b>"+incPackage+"</span>";
			rowHtml+="<span style='width:250px;'><b>��������</b>"+incManf+"</span>"
			rowHtml+="<span style='width:250px;'><b>��Ч��</b>"+Indication+"</span><br>";
			rowHtml+="<span><b>�������Σ�</b>"+Contraindication+"</span><br>";
			rowHtml+="<span><b>������ҵ��</b>"+Ingredient+"</span><br>";

	
		}else if(rowData.GenerName=="ChinaMedPrescData"){ //yuliping ����
			rowHtml+="<span style='width:250px;'><b>�������ƣ�</b>"+incSpec+"</span>";
			rowHtml+="<span style=''><b>������ɣ�</b>"+incPackage+"</span><br>";
			rowHtml+="<span><b>���β�֤��</b>"+incManf+"</span><br>";
		}else if(rowData.GenerName=="LiterSupData"){ 	  //shy ����
			rowHtml+="<span style='width:250px;'><b>�������ƣ�</b>"+incDesc+"</span>";
			rowHtml+="<span style=''><b>������</b>"+origin+"</span><br>";
			rowHtml+="<span><b>�������ڣ�</b>"+ releaseDate+"</span><br>";
			rowHtml+="<span><b>��飺</b>"+shortDesc+"</span><br>";
		}
	}
	if(rowData.title!=undefined){ //kml
		rowHtml+="<div class='para-title level-2'><span style='font-size:22px;background-color:#fff;padding-left:15px;padding-right:5px;'>���</span></div><div style='margin:20px 0;padding-left:20px;'><span>"+rowData.title+"</span></br></div>";	
	}
	if(rowData.remind!=undefined){
		//rowHtml+="<div class='para-title level-2'><span style='font-size:22px;background-color:#fff;padding-left:15px;padding-right:5px;'>��ʾ </span></div><div style='margin:20px 0;padding-left:20px;'><span>"+rowData.remind+"</span></div>";	
	}
	rowHtml+="</div>"
	rowHtml+="</div>"
	return rowHtml;
}

function initPage(){
	$("#pagination").pagination({
		currentPage: 0,
		totalPage: 0,
		isShow: true,
		homePageText: "��ҳ",
		endPageText: "βҳ",
		prevPageText: "��һҳ",
		nextPageText: "��һҳ",
		callback: function(current) {
			initDataGrid(current)
		}
	});
}

//�������
function addClickTimes(dicID,Loginfo){
	runClassMethod("web.DHCCKBDrugSearchLog","WriteDrugClick",{DicID:dicID, Loginfo:Loginfo},function(ret){
		
		})
	}