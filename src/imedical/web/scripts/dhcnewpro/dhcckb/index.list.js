/**
	zhouxin
	2019-07-03
*/
var pageSize=3;
$(function(){
	//initCrumbs(); //链接不要，注释掉
	initDataGrid(1);
	initPage();
})

function initCrumbs(){
	var input=$("#input").val();
	inputNew=input.replace(/[%]/g,"%25") 				//特殊字符处理 kml 2020-03-02
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
			version:$("#version").val(),	// qnp 2021/5/19 增加版本
			drugType:$("#drugType").val(),	// qnp 2021/6/24 增加类型
			promptStr:decodeURI(decodeURI($("#ParStr").val())),      //xww 2021-08-11 增加高级查询条件
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
			
			var totalPage=Math.ceil(data.total/pageSize) //kml 2020-05-11向上取整
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
			rowHtml+="<span style='width:250px;'><b>通用名：</b>"+incSpec+"</span>";
			rowHtml+="<span style='width:250px;'><b>商品名：</b>"+incPackage+"</span>";
			rowHtml+="<span style='width:250px;'><b>活性成份：</b>"+incManf+"</span>"
			rowHtml+="<span style='width:250px;'><b>规格：</b>"+Indication+"</span><br>";
			rowHtml+="<span><b>适应症：</b>"+Contraindication+"</span><br>";
			//rowHtml+="<span><b>禁忌症：</b>"+indication+"</span><br>";

			rowHtml+="<span><b>生产企业：</b>"+Ingredient+"</span><br>";
		}else if(rowData.GenerName=="ChineseHerbalMedicineData"){ //yuliping 中药饮片
			rowHtml+="<span style='width:250px;'><b>饮片名称：</b>"+incSpec+"</span>";
			rowHtml+="<span style='width:250px;'><b>处方应付：</b>"+incPackage+"</span>";
			rowHtml+="<span style='width:250px;'><b>拉丁名：</b>"+incManf+"</span>"
			rowHtml+="<span style='width:250px;'><b>功效：</b>"+Indication+"</span><br>";
			rowHtml+="<span><b>功能主治：</b>"+Contraindication+"</span><br>";
			rowHtml+="<span><b>生产企业：</b>"+Ingredient+"</span><br>";

	
		}else if(rowData.GenerName=="ChinaMedPrescData"){ //yuliping 方剂
			rowHtml+="<span style='width:250px;'><b>方剂名称：</b>"+incSpec+"</span>";
			rowHtml+="<span style=''><b>方剂组成：</b>"+incPackage+"</span><br>";
			rowHtml+="<span><b>主治病证：</b>"+incManf+"</span><br>";
		}else if(rowData.GenerName=="LiterSupData"){ 	  //shy 文献
			rowHtml+="<span style='width:250px;'><b>文献名称：</b>"+incDesc+"</span>";
			rowHtml+="<span style=''><b>出处：</b>"+origin+"</span><br>";
			rowHtml+="<span><b>发布日期：</b>"+ releaseDate+"</span><br>";
			rowHtml+="<span><b>简介：</b>"+shortDesc+"</span><br>";
		}
	}
	if(rowData.title!=undefined){ //kml
		rowHtml+="<div class='para-title level-2'><span style='font-size:22px;background-color:#fff;padding-left:15px;padding-right:5px;'>审查</span></div><div style='margin:20px 0;padding-left:20px;'><span>"+rowData.title+"</span></br></div>";	
	}
	if(rowData.remind!=undefined){
		//rowHtml+="<div class='para-title level-2'><span style='font-size:22px;background-color:#fff;padding-left:15px;padding-right:5px;'>提示 </span></div><div style='margin:20px 0;padding-left:20px;'><span>"+rowData.remind+"</span></div>";	
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
		homePageText: "首页",
		endPageText: "尾页",
		prevPageText: "上一页",
		nextPageText: "下一页",
		callback: function(current) {
			initDataGrid(current)
		}
	});
}

//点击数量
function addClickTimes(dicID,Loginfo){
	runClassMethod("web.DHCCKBDrugSearchLog","WriteDrugClick",{DicID:dicID, Loginfo:Loginfo},function(ret){
		
		})
	}