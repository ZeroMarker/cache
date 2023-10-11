//var _json=[{"ruleId":61465,"alone":true,"rules":[{"name":"rule","remark":"备注备注","lhs":{"criterion":{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"特殊人群","variableName":"91","ruleData":"1480523"},"type":"variable","ruleData":"1480523"},"value":{"constantCategory":"9318","constantName":"9318","constantLabel":"新生儿（足月产）","valueType":"Constant","ruleData":"1480523"},"op":"Equals","ruleData":"1480523"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"7","variableCategory":"患者","variableLabel":"年龄","variableName":"85","ruleData":"1480524"},"type":"variable","ruleData":"1480524"},"value":{"content":"1","contentUom":"4567","contentUomDesc":"周","contentLimit":"","valueType":"InputUom","ruleData":"1480524"},"op":"Equals","ruleData":"1480524"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"5","variableCategory":"西药","variableLabel":"单次给药剂量","variableName":"49","ruleData":"1480525"},"type":"variable","ruleData":"1480525"},"value":{"content":"5","contentUom":"8947","contentUomDesc":"万单位/kg","contentLimit":"","valueType":"InputUom","ruleData":"1480525"},"op":"LessThenEquals","ruleData":"1480525"},{"junctionType":"or","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1480526"},"type":"variable","ruleData":"1480526"},"value":{"content":"00","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1480526"},"op":"Equals","ruleData":"1480526"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"西药","variableLabel":"","variableName":"5","ruleData":"1480527"},"type":"variable","ruleData":"1480527"},"value":{"constantCategory":"4533","constantName":"4533","constantLabel":"滴眼","valueType":"Constant","ruleData":"1480527"},"op":"Equals","ruleData":"1480527"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1480528"},"type":"variable","ruleData":"1480528"},"value":{"content":"11","contentUom":"3931","contentUomDesc":"mg/kg","contentLimit":"22","valueType":"InputLimit","ruleData":"1480528"},"op":"Between","ruleData":"1480528"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"菌属","variableLabel":"","variableName":"11","ruleData":"1480529"},"type":"variable","ruleData":"1480529"},"value":{"content":"2","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"1480529"},"op":"LessThen","ruleData":"1480529"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1480530"},"type":"variable","ruleData":"1480530"},"value":{"content":"33","contentUom":"3924","contentUomDesc":"g","contentLimit":"","valueType":"InputUom","ruleData":"1480530"},"op":"LessThenEquals","ruleData":"1480530"},{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"西药","variableLabel":"","variableName":"5","ruleData":"1480531"},"type":"variable","ruleData":"1480531"},"value":{"constantCategory":"4297","constantName":"4297","constantLabel":"肠营养剂","valueType":"Constant","ruleData":"1480531"},"op":"Equals","ruleData":"1480531"},{"junctionType":"and","criterions":[{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1480532"},"type":"variable","ruleData":"1480532"},"value":{"content":"3","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1480532"},"op":"GreaterThen","ruleData":"1480532"}],"ruleData":"1058790"}],"ruleData":"1058789"},{"junctionType":"and","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"西医疾病","variableLabel":"","variableName":"6","ruleData":"1480533"},"type":"variable","ruleData":"1480533"},"value":{"content":"43","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1480533"},"op":"GreaterThen","ruleData":"1480533"}],"ruleData":"1058791"}],"ruleData":"1058788"}],"ruleData":"1058787"}],"ruleData":"1058786"},{"junctionType":"union","criterions":[{"left":{"leftPart":{"datatype":"String","variableCategoryId":"","variableCategory":"细菌","variableLabel":"","variableName":"10","ruleData":"1480534"},"type":"variable","ruleData":"1480534"},"value":{"content":"03。","contentUom":"","contentUomDesc":"","contentLimit":"","valueType":"Input","ruleData":"1480534"},"op":"Equals","ruleData":"1480534"}],"ruleData":"1058792"}],"ruleData":1058785}},"rhs":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":141,"constantLabel":"通过","ruleData":"1480535"},"ruleData":"1480535"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1480536"},"ruleData":"1480536"},{"actionType":"VariableAssign","type":"variable","variableName":82,"variableLabel":"提示信息","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Input","content":"新生儿 （足月产）：每次按体重5万单位/kg，肌内注射或静脉滴注给药：出生第一周每12小时1次，一周以上者每8小时1次，严重感染每6小时1次。"},"ruleData":"1480537"}]},"other":{"actions":[{"actionType":"VariableAssign","type":"variable","variableName":80,"variableLabel":"通过标记","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":142,"constantLabel":"不通过","ruleData":"1480538"},"ruleData":"1480538"},{"actionType":"VariableAssign","type":"variable","variableName":81,"variableLabel":"管理级别","variableCategory":"药品输出","variableCategoryId":16,"value":{"valueType":"Constant","constantName":137,"constantLabel":"提示","ruleData":"1480539"},"ruleData":"1480539"}]}}]}]
var _json
//var selectBox = [{"value":"and","text":'并且'}, {"value":"or","text":'或者'}, {"value":"union","text":'联合'}, {"value":"additem","text":'添加条件'}, {"value":"addunionitem","text":'添加联合条件'}, {"value":"del","text":'删除'}];
var selectBox = [{"value":"and","text":'并且'}, {"value":"or","text":'或者'}, {"value":"union","text":'联合'}];
var _comboxLogicID //2021-03-25 逻辑下拉框操作-对应逻辑id
var _dicStr="";  //2021-03-25 选中行id^目录id
/*
readme:如果、那么、否则三部分;
如果（svg[path],logic,con）
svg:id=x起始y结束,     data=x起始 P y起始 P y结束
log:id=x起始 Box y结束,后来的后来加了path（给与逻辑出身:为了区分孙子和兄弟的孙子）
con:data=x起始 P y结束,id=x起始 P y起始 T y结束
*/
//var count=1; //最后可直接删除(用于弃用的initCombobox)
var attrsels = "";   //动态面板选择对象
function initPageDefault()
{
	var dicArr=[]; //2021-03-25 st
	$('#selectKeyWords li a', window.parent.document).each(function(index,itm){
		dicArr.push($(itm).attr("id"));
	})
	_dicStr=dicArr.join("^");
	var dicStrLen=_dicStr.split("^").length;
	//alert(_dicStr+" _dicStr  "+_dicStr.split("^").length)
	/*if(dicStrLen<2){ //只适用模板录入，不适用后两个tab
		$.messager.popover({msg: '请选择 药品 和 目录！',timeout: 2000,type:'alert'});
		//return;
	}//ed*/
		
	//$.ajaxSettings.async = false; //设置同步
	$.post("web.DHCCKBRuleBase.cls",{files: ruleId},function(result){
		  _json=JSON.parse(result);
		  //console.log(result)
		  //console.log(_json)
	//});
	//$.ajaxSettings.async = true;
	
	var path=(function(){ //st
	  'use strict'
	  return  function fun(x,y,Object){ 
	      var xx=x-1;
	      var ySt="ySt"+x;
	      var xSt="xSt"+x;
	      var i="i"+x;
	      var Objxx="Obj"+xx;
	      var Objxx=Object;
	      var Obj="Obj"+x;
		  var ySt=y;
		  var xSt=x;
		  PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,Objxx.junctionType); //逻辑
		  var Obj=Objxx.criterions;
		  for (i=0;i<Obj.length; i++) {//--
		  	if(i!=0)y=y+1;
			html = html +displayPathOne(xSt, ySt, y);
			if(Obj[i].op==undefined){
				y=fun(x+1,y,Obj[i]);			 
		    }else{
				PathConHtml=PathConHtml+displayPathCon(x,y,Obj[i],ySt); //内容 //2020-11-09 add ySt
			}
		  }
		  return y;
	  } 
	  
	})()
	var pathLine=path; //ed
	
	//alert(_json[0].rules[0].lhs.criterion)
	//alert(_json[0].rules[0].lhs.criterion.junctionType)
	//alert(_json[0].ruleId)
	$("#line").attr("data_id",_json[0].ruleId);//规则id
	if(_json[0].ruleId==0){
		var colorStyle="";
		if(HISUIStyleCode!="lite"){
			colorStyle=" style='padding:8px'"
		}
		var html='<div style="height:40px; position: relative;">';
		html = html + '<span id="Svg"><svg height="100%" version="1.1" width="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="overflow: hidden; position: relative;">'; //2021-03-27 <span id="Svg"> add
		html = html + '	<desc style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">Created with Rapha?l 2.2.0</desc>'; //hxy 2021-03-27 谷歌ok,ie不兼容问题-在无线状态下画线时线不能显示解决 st add
		html = html + '	<defs style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></defs>'; //ed
		html = html + '</svg></span>';
		var PathSpanHtml=displayPathSpan(1,1,"and"); //第一个逻辑
		html=html+"<div id='PathLog'>"+PathSpanHtml+"</div>"; //逻辑
		html=html+"<div id='PathCon'></div>"; //内容
		html = html + '</div>';

   		//Part2st
		html=html+"<span><div class='kw-chapter'><a></a>正向审查<span class='rule-add-action font-1 ' onclick='addelseItm(1)' style='float:right'><span class='icon-add'"+colorStyle+"></span><span style='padding:0 10px 0 5px'>新增动作</span></span></div></span>"
		//html=html+"<span><strong class='font-12'>正向审查</strong><span class='rule-add-action font-12' onclick='addelseItm(1)'>添加动作</span></span>"
		html=html+"<div id='then' style='' class='ui-sortable'>" //padding: 5px; 2023-03-14样式修改
		html=html+"</div>"			  
		//Part3st			
		html=html+"<div style=margin-top: 5px;>"
		html=html+" <span><div class='kw-chapter'><a></a>逆向审查<span class='rule-add-action font-1 ' onclick='addelseItm(2)' style='float:right'><span class='icon-add'"+colorStyle+"></span><span style='padding:0 10px 0 5px'>新增动作</span></span></div></span>"
		//html=html+" <span><strong class='font-12'>逆向审查</strong><span class='rule-add-action font-12' onclick='addelseItm(2)'>添加动作</span></span>"
		html=html+" <div id='else' style='' class='ui-sortable'>" //padding: 5px 2023-03-14样式修改	    
		html=html+" </div>"
		html=html+"</div>"
		$("#line").html(html);
		
		if(dicStrLen>1){//2021-03-25 st
			var PathFlag = serverCall("web.DHCCKBCommon","GetCalcPathByDicID",{"DicID":_dicStr.split("^")[1]})
			//addelseItm(1)
			var quetyHtml=serverCall("web.DHCCKBRuleEditor","QueryDrugOutputAttr",{})		
			if(PathFlag==1){
				$("#then").append(quetyHtml);
			}else{
				$("#else").append(quetyHtml);
			}
		} //ed
		
	}else{
	$("#remark").val(_json[0].rules[0].remark);//备注
	$("#rulename").val(_json[0].rules[0].name);//名称
	var junctionType=_json[0].rules[0].lhs.criterion.junctionType;
	var Obj1=_json[0].rules[0].lhs.criterion.criterions;
	var x=1,y=1,height=100,html="",PathSpanHtml="",PathConHtml="";
	html = html + '<span id="Svg"><svg height="100%" version="1.1" width="100%" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" style="overflow: hidden; position: relative;">'; //2021-03-27 <span id="Svg"> add
	html = html + '<desc style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);">Created with Rapha?l 2.2.0</desc>';
	html = html + '<defs style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></defs>';
	PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,junctionType); //第一个逻辑
	for (i=0; i<Obj1.length; i++) {
		 if(i!=0)y=y+1;
		 html = html +displayPathOne(1, 1, y);
		 if(Obj1[i].op==undefined){///
			  y=pathLine(x+1,y,Obj1[i]);
			  /*x=2;
				 var ySt2=y;
				 var xSt2=x;
				 PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,Obj1[i].junctionType); //逻辑
				 var Obj2=Obj1[i].criterions;
				 for (i2=0; i2<Obj2.length; i2++) {//--
				 //alert(2+"**"+j)
				   if(i2!=0)y=y+1;
							html = html +displayPathOne(xSt2, ySt2, y);
							if(Obj2[i2].op==undefined){///
							  x=3;
								 var ySt3=y;
								 var xSt3=x;
								 PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,Obj2[i2].junctionType); //逻辑
								 var Obj3=Obj2[i2].criterions;
								 for (i3=0;i3<Obj3.length; i3++) {//--
								 //alert(3+"**"+k)
								   if(i3!=0)y=y+1;
											html = html +displayPathOne(xSt3, ySt3, y);
											if(Obj3[i3].op==undefined){///
											  x=4;
								     var ySt4=y;
								     var xSt4=x;
								     PathSpanHtml=PathSpanHtml+displayPathSpan(x,y,Obj3[i3].junctionType); //逻辑
								     var Obj4=Obj3[i3].criterions;
								     for (i4=0; i4<Obj4.length; i4++) {//--
													 //alert(4+"**"+l)
													   if(i4!=0)y=y+1;
																html = html +displayPathOne(xSt4, ySt4, y);
																if(Obj4[i4].op==undefined){}
								     }
												
											}
								 }//--
				   }
				 }//-- */
	   	}else{
		    PathConHtml=PathConHtml+displayPathCon(1,y,Obj1[i],1); //第一个内容 //2020-11-09 add ,1
		}
			
	}	
	//html = html + '<path fill="none" stroke="#777777" d="M45,16C45,16,45,16,80,16" style="-webkit-tap-highlight-color: rgba(0, 0, 0, 0);"></path>';
	//html=html+displayPathSpan(1,1,junctionType); //第一个逻辑
	html = html + '</svg></span>'; //hxy 2021-03-27 add
	html=html+"<div id='PathLog'>"+PathSpanHtml+"</div>"; //逻辑
	html=html+"<div id='PathCon'>"+PathConHtml+"</div>"; //内容
	

	height=y*45; //原：height=y*30; 2023-03-14 样式修改
	if(height==45)height=55 //原：if(height==30)height=40 2023-03-14 样式修改
	html = '<div style="height:'+height+'px; position: relative;">'+html;
	//html = html + '</svg>'; //hxy 2021-03-27 注释 上移至逻辑前
	html = html + '</div>';
	
	$("#line").html(html);

	//Part2st
	var rhs=_json[0].rules[0].rhs.actions;
	
	var colorStyle="";
	if(HISUIStyleCode!="lite"){
		colorStyle=" style='padding:8px'"
	}
	var htmlTwo="<span style='line-height:25px'><div class='kw-chapter'><a></a>正向审查<span class='rule-add-action font-1 ' onclick='addelseItm(1)' style='float:right'><span class='icon-add'"+colorStyle+"></span><span style='padding:0 10px 0 5px'>新增动作</span></span></div></span>"
	//var htmlTwo="<span style='line-height:25px'><strong class='font-12'>正向审查</strong><span class='rule-add-action font-12' onclick='addelseItm(1)'>添加动作</span></span>"
	htmlTwo=htmlTwo+"<div id='then' style='' class='ui-sortable'>" //padding: 5px; 2023-03-14样式修改
	for (i=0; i<rhs.length; i++) {
		 htmlTwo=htmlTwo+"<div class='rule-action' id='"+rhs[i].ruleData+"' data_type='"+rhs[i].value.valueType+"'>" //2020-12-03 data_type
		 //htmlTwo=htmlTwo+"<i class='glyphicon glyphicon-remove rule-delete-action'></i>"
		 htmlTwo=htmlTwo+"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
		 //htmlTwo=htmlTwo+"<span class='icon icon-remove' onclick='deleteAction(this)'>&nbsp;</span>"
		 htmlTwo=htmlTwo+"<span style='padding-left:4px'> "//2020-12-03 add
		 htmlTwo=htmlTwo+"	<span class='line-green'>变量赋值:</span>"
		 htmlTwo=htmlTwo+" <span class='blank'>.</span>"
		 htmlTwo=htmlTwo+" <span class='line-darkcyan-zero' onclick='chooseVar(this)' par_data='"+rhs[i].variableCategoryId+"' data_id='"+rhs[i].variableName+"'>"+rhs[i].variableCategory+"的"+rhs[i].variableLabel+"</span>"
		 htmlTwo=htmlTwo+" <span style='color: red;padding-left:8px'>=</span>"
		 htmlTwo=htmlTwo+" <span class='blank'>.</span>"
		 htmlTwo=htmlTwo+" <span>"//2020-12-03 add
		 if(rhs[i].value.valueType=="Constant"){
			htmlTwo=htmlTwo+" <span class='line-blue' onclick='chooseDataset(this)' data_id='"+rhs[i].value.constantName+"'>"+rhs[i].value.constantLabel+"</span>"
		 }else{
			//htmlTwo=htmlTwo+" <span class='line-brown'>"+rhs[i].value.content+"</span>"
			var conValue=rhs[i].value.content;
			htmlTwo=htmlTwo+"		<span class='line-brown' onclick='viewInput(this)'>"+conValue+"</span>"
			htmlTwo=htmlTwo+"		<input class='hisui-validatebox textbox result-input' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>"
		 }
		 htmlTwo=htmlTwo+" </span>"//2020-12-03 add
		 htmlTwo=htmlTwo+" <span class='blank'>.</span>"
		 htmlTwo=htmlTwo+"</span>"//2020-12-03 add
		 //htmlTwo=htmlTwo+"<span class='icon icon-cancel'>&nbsp;</span>" //放前边更合理
		 htmlTwo=htmlTwo+"</div>";
	}
	htmlTwo=htmlTwo+"</div>"			  
	$("#line").append(htmlTwo);
	
	//Part3st
	var other=_json[0].rules[0].other.actions;
 	var htmlThr="<div style=margin-top: 5px;>"
 	htmlThr=htmlThr+" <span style='line-height:25px'><div class='kw-chapter'><a></a>逆向审查<span class='rule-add-action font-1' onclick='addelseItm(2)' style='float:right'><span class='icon-add'"+colorStyle+"></span><span style='padding:0 10px 0 5px'>新增动作</span></span></div></span>"
	//htmlThr=htmlThr+" <span style='line-height:25px'><strong class='font-12'>逆向审查</strong><span class='rule-add-action font-12' onclick='addelseItm(2)'>添加动作</span></span>"
	htmlThr=htmlThr+" <div id='else' style='' class='ui-sortable'>"	//padding: 5px; 2023-03-14样式修改   
	for (i=0; i<other.length; i++) {
		htmlThr=htmlThr+"  <div class='rule-action' id='"+other[i].ruleData+"' data_type='"+other[i].value.valueType+"'>"
		//htmlThr=htmlThr+"  <i class='glyphicon glyphicon-remove rule-delete-action'></i>"
		htmlThr=htmlThr+"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
		//htmlThr=htmlThr+"<span class='icon icon-remove' onclick='deleteAction(this)'>&nbsp;</span>"
		htmlThr=htmlThr+"<span style='padding-left:4px'>"//2020-12-03 add
		htmlThr=htmlThr+"  <span class='line-green'>变量赋值:</span>"
		htmlThr=htmlThr+"  <span class='blank'>.</span>"
		htmlThr=htmlThr+"  <span class='line-darkcyan-zero' onclick='chooseVar(this)' par_data='"+other[i].variableCategoryId+"' data_id='"+other[i].variableName+"'>"+other[i].variableCategory+"的"+other[i].variableLabel+"</span>"
		htmlThr=htmlThr+"  <span style='color: red;padding-left:8px'>=</span>"
		htmlThr=htmlThr+"  <span class='blank'>.</span>"
		htmlThr=htmlThr+"  <span>"//2020-12-03 add
		if(other[i].value.valueType=="Constant"){
			htmlThr=htmlThr+" <span class='line-blue' onclick='chooseDataset(this)' data_id='"+other[i].value.constantName+"'>"+other[i].value.constantLabel+"</span>"
		}else{
			//htmlThr=htmlThr+" <span class='line-brown'>"+other[i].value.content+"</span>"
			var conValue=other[i].value.content;
			htmlThr=htmlThr+"			<span class='line-brown' onclick='viewInput(this)'>"+conValue+"</span>"
			htmlThr=htmlThr+"			<input class='hisui-validatebox textbox result-input' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>"
		}
		htmlThr=htmlThr+"  </span>"//2020-12-03 add
		//htmlThr=htmlThr+"<span class='line-blue'>"+other[i].value.constantLabel+"</span>"
		htmlThr=htmlThr+"<span class='blank'>.</span>"
		htmlThr=htmlThr+"</span>"//2020-12-03 add
		//htmlThr=htmlThr+"<span class='icon icon-cancel'>&nbsp;</span>" //放前边更合理
		htmlThr=htmlThr+"  </div>"
	}
	htmlThr=htmlThr+" </div>"
 	htmlThr=htmlThr+"</div>"
	$("#line").append(htmlThr);
 }//2020-12-07
 }); //2020-12-09 

 //displayPathAppend(1, 1, 7);//追加一条线
 //displayPathAppend(2, 2, 5);//追加一条线
 //displayPathConAppend(1,1,1);//追加一条内容
 //displayPathLogicAppend(1,2);//追加一个逻辑
 
 //initCombobox();
 //displayCombobox("selBox11","or");
 $("body").on('dblclick',function(e){
 	AllUlPanel();
 });

}

///添加动作then/else
function addelseItm(other)
{
	var otherId = other==1?'then':'else';

	var html = ""
	html = html +"<div class='rule-action' id='0' data_type=''>" // //hxy 2020-12-03 add 0
	html = html +"<span class='icon icon-cancel' onclick='deleteAction(this)'>&nbsp;</span>"
	//html = html +"<span class='icon icon-remove' onclick='deleteAction(this)'>&nbsp;</span>"
	html = html +"<span style='padding-left:4px'>"//hxy 2020-12-03 add
	html = html +"	<span class='line-green'>变量赋值:</span>"
	html = html +"	<span class='blank'>.</span>" //hxy 2020-12-03 add
	html = html +"	<span class='line-darkcyan-zero' par_data='' data_id='' onmouseover='chooseVar(this)'>请选择变量1</span>"  //sufan 新增par_data=''
	html = html +"	<span style='color: red;padding-left:8px'>=</span>"
	html = html +"	<span class='blank' onclick='chooseType(this,1)'>.</span>"
	html = html +"	<span></span>"
	html = html +"</span>"//hxy 2020-12-03 add
	html = html +"</div>";
	$("#"+otherId).append(html);
}

//画单线
function displayPathOne(xLev, ySt, yEd)
{	
	var stX=(xLev-1)*105+45; //原：var stX=(xLev-1)*75+45; 2023-03-14 内容靠右边
	var stY=(ySt-1)*45+20; //原：var stY=(ySt-1)*30+16; 2023-03-14样式修改
	var edX=stX+67; //原：var edX=stX+35; 2023-03-14样式修改 导致删除逻辑的替换会出错，替换结束x为新的结束Y 37->67
	var site=(yEd-ySt)*45+stY; //原：var site=(yEd-ySt)*30+stY; 2023-03-14样式修改
	var d="M"+stX+","+stY+"C"+stX+","+site+","+stX+","+site+","+edX+","+site;
	var rtn=" <path id='"+xLev+"P"+yEd+"' data='"+xLev+"P"+ySt+"P"+yEd+"' fill='none' stroke='#3197F4' d='"+d+"' style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'></path>" //#777777
 	return rtn;
}

//画单线-append
function displayPathAppend(xLev, ySt, yEd,delFlag)
{	
	var stX=(xLev-1)*105+45; //原：var stX=(xLev-1)*75+45; 2023-03-14 内容靠右边
	var stY=(ySt-1)*45+20; //原：var stY=(ySt-1)*30+16; 2023-03-14样式修改
	var edX=stX+67; //原：var edX=stX+35; 2023-03-14样式修改 导致删除逻辑的替换会出错，替换结束x为新的结束Y 37->67
	var site=(yEd-ySt)*45+stY; //原：var site=(yEd-ySt)*30+stY; 2023-03-14样式修改
	var d="M"+stX+","+stY+"C"+stX+","+site+","+stX+","+site+","+edX+","+site;
	var rtn=" <path id='"+xLev+"P"+yEd+"' data='"+xLev+"P"+ySt+"P"+yEd+"' fill='none' stroke='#3197F4' d='"+d+"' style='-webkit-tap-highlight-color: rgba(0, 0, 0, 0);'></path>"; //#777777
	var rtn=$("#Svg").html().replace("</svg>","")+rtn+"</svg>"; //hxy 2021-03-27 谷歌ok,ie不兼容问题-画线时取svg标签解决st
	$($("#Svg")).html(rtn);
//	var rtn=$("#line>div>svg").html()+rtn;
//	$($("#line>div>svg")).html(rtn); //ed
  	//$($("#line>div>svg")).after(rtn);
  	if(ySt!=yEd){
  	var height=$("#line>div:first").height()+45; //原：var height=$("#line>div:first").height()+30; 2023-03-14样式修改
  	if(yEd*45>height){height=yEd*45;} //原：if(yEd*30>height){height=yEd*30;} 2023-03-14样式修改
  	if(delFlag==1){height=$("#line>div:first").height();} //2020-11-09
  	$($("#line>div:first")).height(height);
  	}
}

//逻辑关系位置
function displayPathSpan(xLev, yLev, type)
{
	 /*switch (type) {
    case "and":
        type = "并且";
        break; 
    case "or":
        type = "或者";
        break; 
    default: 
    } */

	var left=(xLev-1)*105+5; //原：var left=(xLev-1)*75+5; 2023-03-14 内容靠右边
	var top=(yLev-1)*45+5; //原：var top=(yLev-1)*30+5; 2023-03-14样式修改
	var rtn= "<span class='PathLog' style='position: absolute; left: "+left+"px; top: "+top+"px;'>";
	//rtn=rtn+" <input id='"+xLev+"*"+yLev+"' class='hisui-combobox' style='width:65px;'/></span>";
	rtn=rtn+" <input id='"+xLev+"Box"+yLev+"' data='"+type+"' class='hisui-combobox' style='width:65px;'/></span>"; //2020-11-20 add data

	var id=xLev+"Box"+yLev;
	//displayCombobox(id,type);
	setTimeout(function(){ 
	 	displayCombobox(id,type);
	}, 0.01);
	return rtn;
}

//内容位置
function displayPathCon(xLev, yLev, con,yLevSt) //2020-11-09 add ,yLevSt
{
	//alert(xLev+"**"+yLev)
	var op=con.op;
	var opCode=op;//20201126
	switch (con.op) {
		case "GreaterThen":
		    op = "大于";
		    break; 
		case "GreaterThenEquals":
		    op = "大于或等于";
		    break;
	    case "Equals":
	        op = "等于";
	        break;  
	    case "NotEquals":
	        op = "不等于";
	        break;
	    case "Between":
	        op = "在";
	        break;
	    case "In":
	        op = "在集合";
	        break;
	    case "LessThen":
	        op = "小于";
	        break;
	    case "LessThenEquals":
	        op = "小于或等于";
	        break; 
	    default: 
    } 
	var left=xLev*105+5; //原：var left=xLev*75+5; 2023-03-14 内容靠右边
	var top=(yLev-1)*45+10; //原：(yLev-1)*30+10 2023-03-14样式修改
	var htmlOne="<div data='"+xLev+"P"+yLev+"' id='"+xLev+"P"+yLevSt+"T"+yLev+"' data_type='"+con.value.valueType+"' data_rule='"+con.left.ruleData+"' data_cate='"+con.left.leftPart.variableCategoryId+"' data_name='"+con.left.leftPart.variableName+"' style='position: absolute; left: "+left+"px; top: "+top+"px;'>"
	htmlOne=htmlOne+"	<span style='font-size:12px;padding-right:4px'>"
	var Label=con.left.leftPart.variableLabel;
	if(Label!="")Label="的"+Label;
	htmlOne=htmlOne+"  <span class='line-darkcyan' onclick='chooseVar(this)' par_data='"+con.left.leftPart.variableCategoryId+"' data_id='"+con.left.leftPart.variableName+"'>"+con.left.leftPart.variableCategory+Label+"</span>" //20201130 par_data、data_id
	htmlOne=htmlOne+"  <span class='line-red' onclick='chooseOpera(this)' data='"+opCode+"'>"+op+"</span>"
	htmlOne=htmlOne+"  <span class='blank' onclick='chooseType(this)'>&nbsp;</span>" //2020-11-13
	htmlOne=htmlOne+"  <span>" //2020-11-13
	var conValue="";//11-16
	if(con.value.valueType=="Constant"){
		htmlOne=htmlOne+"		<span class='line-blue' onclick='chooseDataset(this)' data_id='"+con.value.constantName+"'>"+con.value.constantLabel+"</span>" //2020-12-02 add onclick
	}else if(con.value.valueType=="InputLimit"){ //2020-12-18 st
		conValue="("+con.value.content+"-"+con.value.contentLimit+")";//11-16
		htmlOne=htmlOne+"		<span class='line-brown' onclick='viewInput(this)'>("+con.value.content+"-"+con.value.contentLimit+")</span>"
		htmlOne=htmlOne+"		<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide1(this)' style='display: none;'>"
 		htmlOne=htmlOne+"		<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide2(this)' onclick='inputHide1B2(this)'style='display: none;'>"
 		htmlOne=htmlOne+"		<span class='line-blue' onclick='chooseUnit(this)' data_id='"+con.value.contentUom+"'>"+con.value.contentUomDesc+"</span>"
	}else if(con.value.valueType=="InputUom"){
		conValue=con.value.content;//11-16
		htmlOne=htmlOne+"		<span class='line-brown' onclick='viewInput(this)'>"+con.value.content+"</span>"
		htmlOne=htmlOne+"		<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>" //11-16 11-17
		htmlOne=htmlOne+"		<span class='line-blue' onclick='chooseUnit(this)' data_id='"+con.value.contentUom+"'>"+con.value.contentUomDesc+"</span>"
	}else{//Input
		conValue=con.value.content;//11-16
		htmlOne=htmlOne+"		<span class='line-brown' onclick='viewInput(this)'>"+con.value.content+"</span>"
		htmlOne=htmlOne+"		<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>" //11-16 11-17
	}
	/*}else{
		if(((con.op=="Between")||(con.op=="In")&&(con.value.contentLimit!=""))){ //Between和集合的limit不为空时:有括号，有区间
			conValue="("+con.value.content+"-"+con.value.contentLimit+")";//11-16
			htmlOne=htmlOne+"		<span class='line-brown' onclick='viewInput(this)'>("+con.value.content+"-"+con.value.contentLimit+")</span>"
			htmlOne=htmlOne+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide1(this)' style='display: none;'>"
 			htmlOne=htmlOne+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide2(this)' onclick='inputHide1B2(this)'style='display: none;'>"
		}else{
			conValue=con.value.content;//11-16
			htmlOne=htmlOne+"		<span class='line-brown' onclick='viewInput(this)'>"+con.value.content+"</span>"
			htmlOne=htmlOne+"		<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>" //11-16 11-17
 		}
		//htmlOne=htmlOne+"		<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;' value='"+conValue+"'>" //11-16 11-17
		htmlOne=htmlOne+"		<span class='line-blue' onclick='chooseUnit(this)' data_id='"+con.value.contentUom+"'>"+con.value.contentUomDesc+"</span>"
	}*/ //ed
	htmlOne=htmlOne+"  </span><span>" //2020-11-16 内容一个span;之间、之中一个span;
	if(con.op=="Between")htmlOne=htmlOne+"		<span class='line-red'><strong>之间</strong></span>"
	if(con.op=="In")htmlOne=htmlOne+"		<span class='line-red'><strong>之中</strong></span>"
    htmlOne=htmlOne+" </span>" //2020-11-13 
    
    if (con.value.extconstvar!="") { //2022-04-20 qnp 放消息级别
     htmlOne=htmlOne+' <span data_cate="' +con.value.extconstvar+'">('
     htmlOne=htmlOne+' <span class="lineext-darkcyan" onclick="chooseLevelVar(this)" data_id="'+con.value.extconst+'" par_data="">'+con.value.extconstName+'</span>'
     htmlOne=htmlOne+' <span style="color: #EE0F0F;">=</span>' //red
     htmlOne=htmlOne+' <span><span onclick="chooseDatasetlevel(this)" data_id="'+con.value.extconstvar+'" class="lineext-blue">'+ con.value.extconstvarName +'</span></span>)</span>'
	}
	else{
		htmlOne=htmlOne+"  <span class='manlevopeator icon icon-edit' onclick='chooseManLevCombox(this)'></span>" //icon-write-order
	}
	htmlOne=htmlOne+"	</span>"
	htmlOne=htmlOne+"	<span class='icon icon-cancel' onclick='deleteCon(this)'>&nbsp;</span>"
	//htmlOne=htmlOne+"	<span class='icon icon-remove' onclick='deleteCon(this)'>&nbsp;</span>"
	htmlOne=htmlOne+"</div>"
	return htmlOne;
}

//画内容-append
function displayPathConAppend(xLev, yLevSt, yLev)
{	
	var left=xLev*105+5; //原：var left=xLev*75+5; 2023-03-14 内容靠右边
	var top=(yLev-1)*45+10; //原:var top=(yLev-1)*30+10; 2023-03-14样式修改
	var htmlOne="<div data='"+xLev+"P"+yLev+"' id='"+xLev+"P"+yLevSt+"T"+yLev+"' data_type='' data_rule='0' data_cate='' data_name='' style='position: absolute; left: "+left+"px; top: "+top+"px;'>"
	htmlOne=htmlOne+"	<span style='font-size:12px;padding-right:4px'>"
	htmlOne=htmlOne+"  <span class='line-darkcyan' par_data='' data_id='' onmouseover='chooseVar(this)'>请选择变量1</span>"			//sufan 新增 par_data
	htmlOne=htmlOne+"  <span class='line-red' onmouseover='chooseOpera(this)'>请选择比较操作符</span>"
	htmlOne=htmlOne+"  <span class='blank' onclick='chooseType(this)'>&nbsp;</span>"
	htmlOne=htmlOne+"  <span></span>" //2020-11-16 为了放请输入值等 
	htmlOne=htmlOne+"  <span></span>" //2020-11-13
	htmlOne=htmlOne+"  <span class='manlevopeator icon icon-edit' onclick='chooseManLevCombox(this)'></span>" //2022-04-20 qnp 放消息级别 //	<img src='../scripts/dhcnewpro/dhcckb/images/ruleindex_editman.png' alt=''/>
	htmlOne=htmlOne+"	</span>"
	htmlOne=htmlOne+"	<span class='icon icon-cancel' onclick='deleteCon(this)'>&nbsp;</span>"
	//htmlOne=htmlOne+"	<span class='icon icon-remove' onclick='deleteCon(this)'>&nbsp;</span>"
	htmlOne=htmlOne+"</div>"
    //$($("#line>div")).append(htmlOne);
    //var rtn=$("#line").html()+htmlOne;
    //$($("#line")).html(rtn);
    $("#PathCon").append(htmlOne);
}

//画逻辑-append
function displayPathLogicAppend(xLev, yLev)
{
	var left=(xLev-1)*105+5; //原：var left=(xLev-1)*75+5; 2023-03-14 内容靠右边
	var top=(yLev-1)*45+5; //原:var top=(yLev-1)*30+5; 2023-03-14样式修改
	var HtmlLog= "<span class='PathLog' style='position: absolute; left: "+left+"px; top: "+top+"px;'>";
	//HtmlLog=HtmlLog+ " <span style='font-size: 11pt'>或者</span><i class='glyphicon glyphicon-chevron-down rule-join-node'></i></span>";
	HtmlLog=HtmlLog+" <input id='"+xLev+"Box"+yLev+"' data='and' class='hisui-combobox' style='width:65px;'/></span>"; //20201201默认and
    var id=xLev+"Box"+yLev; //2020-11-04 st
	setTimeout(function(){ 
		displayCombobox(id,"and");
	}, 0.01); //ed
	$("#PathLog").append(HtmlLog)
}

///逻辑下拉框
function displayCombobox(id,type)
{
	var pathYEd=(function(){ //2020-11-11 st 找应该的yEd
	  'use strict'
	  return  function fun(pathData,yRtn){
		 pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
			if(pathData!=undefined){
				yRtn=parseInt(pathData.split("P")[2]);
				var pathDataX=parseInt(pathData.split("P")[0]);
				var pathDataYEd=parseInt(pathData.split("P")[2]);
				var pathData=(pathDataX+1)+"P"+pathDataYEd+"P";
				var yRtn=fun(pathData,yRtn);
			}
	     return yRtn;
	  }   
	})()
	var getRealYEd=pathYEd; //ed
 
 	if($("#"+id).attr("path")==undefined){//20201201 st 增删修改逻辑出身
 	var x1=parseInt(id.split("Box")[0]); //202001125 给逻辑以出身st
	var y1=parseInt(id.split("Box")[1]);
	var lastPath=(x1-1)+"P"+y1;
	var lastData=$("#"+lastPath).attr("data");
	$("#"+id).attr("path",lastData); //ed
	}else{
	 /*alert($("#"+id).attr("path")+"  ** "+id)
	 var pathNow=$("#"+id).attr("path");
	 var pathNowX=parseInt(pathNow.split("P")[0]);
	 var pathNowY=parseInt(pathNow.split("P")[1]);
	 //alert(pathNowY+"  && "+y1)
	 var pathNowYEd=parseInt(pathNow.split("P")[2]);
	 if(operate=="add"){
		 if(pathNowY<=y1){
			 pathNowY=pathNowY+1;
			}
		 pathNowYEd=pathNowYEd+1;
		 pathNow=pathNowX+"P"+pathNowY+"P"+pathNowYEd;
		 $("#"+id).attr("path",pathNow);
	 }
	 if(operate=="del"){
		 if(pathNowY>=y1){
			 pathNowY=pathNowY-1;
			}
		 pathNowYEd=pathNowYEd-1;
		 pathNow=pathNowX+"P"+pathNowY+"P"+pathNowYEd;
		 $("#"+id).attr("path",pathNow);
	 }*/
	}
 
	var selVal = "";
	$HUI.combobox("#"+id,{
		valueField:'value',
		textField:'text',
		panelHeight:'auto', //hxy 2021-03-24 "210"->auto
		mode:'remote',
		data:selectBox,
		onSelect:function(ret){
			if(selVal != ""){
				$HUI.combobox("#"+id).setValue(selVal);
			}
			var x1=parseInt(id.split("Box")[0]);
			var y1=parseInt(id.split("Box")[1]);
			if(ret.value=="additem") //添加条件
			{
				pathData=id.replace("Box","P")+"P"; //2020-11-11 st
				var numPath=$("#line").find("path[data^='"+pathData+"']").size(); 
				//alert(pathData+"  pathData  "+numPath)
				if(numPath==0){
					var y2=y1;
				}else{
					 yRtn=getRealYEd(pathData);
					 /*var yRtn="";
					 pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
						if(pathData!=undefined){
							yRtn=parseInt(pathData.split("P")[2]);
							var pathDataX=parseInt(pathData.split("P")[0]);
							var pathDataYEd=parseInt(pathData.split("P")[2]);
							var pathData=(pathDataX+1)+"P"+pathDataYEd+"P";
							pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
							if(pathData!=undefined){
								yRtn=parseInt(pathData.split("P")[2]);
								var pathDataX=parseInt(pathData.split("P")[0]);
								var pathDataYEd=parseInt(pathData.split("P")[2]);
								var pathData=(pathDataX+1)+"P"+pathDataYEd+"P";
								pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
							}
						}*/
					resetHtmlAdd(x1,yRtn);
					var y2=yRtn+1;//y2=y1+numPath;
					//resetHtmlAdd(x1,y2-1);
				}//ed	
				displayPathAppend(x1,y1,y2); //画path
				displayPathConAppend(x1,y1,y2); //画con
			}
			if(ret.value=="addunionitem"){ //添加联合条件
				var x2=parseInt(x1)+1;
				pathData=id.replace("Box","P")+"P"; //2020-11-11 st
				var numPath=$("#line").find("path[data^='"+pathData+"']").size(); 
				//alert(pathData+"  pathData  "+numPath)
				if(numPath==0){
					y2=y1;
				}else{
					yRtn=getRealYEd(pathData);
					resetHtmlAdd(x1,yRtn);
					y2=yRtn+1;
					//y2=y1+numPath;
					//resetHtmlAdd(x1,y2-1);
				}//ed	
				displayPathAppend(x1,y1,y2); //画path
	   			displayPathLogicAppend(x2,y2); //画logic
			}
		    if(ret.value=="del"){
			  //alert(x1+"*"+y1+"*"+id)
			  if(id=="1Box1"){return} //2020-12-10
			  if($("#PathCon").find("[data^="+x1+"P"+y1+"]").size()){
				  $.messager.alert("提示:","请先删除当前连接下子元素！","info");
				  return;
			  }
			  var bOXId=(parseInt(x1)+1)+"Box"+y1; //2020-11-10 st 逻辑框1-逻辑框2时，逻辑框1不能被删除；
			  var number=$("#PathLog").find("#"+bOXId).size();
			  if(number>0){
				  $.messager.alert("提示:","请先删除当前连接下子元素！","info");
				  return;
			  } //ed
			  deleteLogic(x1,y1,id);
			  //resetHtml(x1,y1); //2020-11-10 判断满足number小于1再调用
			  var bOXId=(parseInt(x1)-1)+"Box"+y1; //2020-11-10 st 逻辑同行时（逻辑框1-逻辑框2）,删除逻辑2不需resetHtml和减小高度
			  var number=$("#PathLog").find("#"+bOXId).size();
			  var bOXId=bOXId.replace("Box","P")+"P";
			  var numberPath=$("#line").find("path[data^='"+bOXId+"']").size(); //2020-11-10 有同父的同级的path时，即使满足number=1，也要reset
			  //alert(number+"*"+numberPath)
			  if((number<1)||(numberPath>0)){ //if(number<1){
				  resetHtml(x1,y1);
				  height=$("#line>div:first").height()-45; //2020-11-10 st 删除逻辑的同时,调整高度 //原：30; 2023-03-14样式修改
				  if(height==45)height=55; //原：if(height==30)height=40; 2023-03-14样式修改
	 				$("#line>div:first").height(height); //ed
			  } //ed
			  //alert(bOXId+" bOXId "+number)
			  
			  $(".combo-p").css("display","none");
			  return;
			 }
			 
			 ComboxOpHide(); //逻辑操作面板隐藏 2021-03-25
		},
		onChange:function(newValue,oldValue)
		{
			if((newValue != "and")&&(newValue != "or")&&(newValue != "union"))
			{
				selVal = oldValue;
				$HUI.combobox("#"+id).setValue(oldValue);
			}else{
				selVal = newValue;
				$("#"+id).attr("data",selVal);//20201201
			}
			
		},
		onShowPanel:function(){ //2021-03-25
			ComboxOpHide(); //逻辑操作面板隐藏
		},
		onLoadSuccess:function(data)
		{
		    $HUI.combobox("#"+id).setValue(type);
		}
	})
	
	ComboxOpInit();//2021-03-25
}

/*//逻辑下拉框的选择
function initCombobox()
{
	var selVal = "";
	$HUI.combobox("#selBox",{
		valueField:'value',
		textField:'text',
		panelHeight:"210",
		mode:'remote',
		data:selectBox,
		onSelect:function(ret){
			if(selVal != ""){
				$HUI.combobox("#selBox").setValue(selVal);
			}
			if((ret.value != "and")&&(ret.value != "or")&&(ret.value != "union"))
			{
				var y1=2
				var y2=2
				var y2=y2+count
				count = count+1
				var retval = displayPathAppend(1,y1,y2);
				//displayPathSpan(1,y2,ret.value)
			}
			
		},
		onChange:function(newValue,oldValue)
		{
			if((newValue != "and")&&(newValue != "or")&&(newValue != "union"))
			{
				selVal = oldValue;
				$HUI.combobox("#selBox").setValue(oldValue);
			}else{
				selVal = newValue;
			}
			
		},
		onLoadSuccess:function(data)
        {
           $HUI.combobox("#selBox").setValue("or");
        }
	})
}*/

///删除动作
function deleteAction(action){
	//$(action).parent().empty();
	$(action).parent().remove();
}

///删除Con+path
function deleteCon(Con){
	var pathId=$(Con).parent().attr("data");
	$(Con).parent().remove();
	$("#"+pathId).remove();
	var conId=$(Con).parent().attr("id").split("T")[0]+"P";
	var number=$("#line").find("path[data^='"+conId+"']").size(); //2020-11-09
	//alert(conId+"*"+number)
	//resetHtmlByCon(pathId.split("P")[0],pathId.split("P")[1]);//2020-11-06
	if(number!=0){ //2020-11-09 st
		resetHtmlByCon(pathId.split("P")[0],pathId.split("P")[1]);
		height=$("#line>div:first").height()-45; //2020-11-09 st 删除内容的同时,调整高度 //原：30 2023-03-14样式修改
		if(height==45)height=55; //原：if(height==30)height=40; 2023-03-14样式修改
 		$("#line>div:first").height(height); 
	}
	
}

///删除Logic+path
function deleteLogic(x1,y1,id){
	var pathId=(x1-1)+"P"+y1;
	$("#"+id).parent().remove();
	$("#"+pathId).remove();	
}

///删除logic后需上移内容上移；
function resetHtml(x1,y1){
	$("#PathLog").find(".PathLog").each(function(){ //logic
	 	var seatY=parseInt($(this).find("input").attr('id').split("Box")[1]);
		var seatX=parseInt($(this).find("input").attr('id').split("Box")[0]); //2020-11-10
		if(seatY>y1){
			seatT=$(this).css('top').split("px")[0]-45+"px"; //原：30 2023-03-14样式修改
			$(this).css("top",seatT);
			 	
			var seatId=seatX+"Box"+(seatY-1); //2020-11-10 st 被上移逻辑id同步修改
			$(this).find("input").attr("id",seatId);
			var type=$HUI.combobox("#"+seatId).getValue();
			displayCombobox(seatId,type); //ed
				 
			//alert($("#"+seatId).attr("path")+"  ** "+seatId) //20201201 逻辑出身的对应修改st
		    var pathNow=$("#"+seatId).attr("path");
		    var pathNowX=parseInt(pathNow.split("P")[0]);
		    var pathNowY=parseInt(pathNow.split("P")[1]);
		    var pathNowYEd=parseInt(pathNow.split("P")[2]);
			if(pathNowY>y1){
				pathNowY=pathNowY-1;
			}
			pathNowYEd=pathNowYEd-1;
			pathNow=pathNowX+"P"+pathNowY+"P"+pathNowYEd;
			$("#"+seatId).attr("path",pathNow);//ed
				 
		}  
	});
	
	$("#PathCon").find("div").each(function(){ //content
		var seatY=parseInt($(this).attr('data').split("P")[1]);
		var seatX=parseInt($(this).attr('data').split("P")[0]); //2020-11-10
	 	if(seatY>y1){
			seatT=$(this).css('top').split("px")[0]-45+"px"; //原：30 2023-03-14样式修改
		 	$(this).css("top",seatT);
		 	
		 	var seat=seatX+"P"+(seatY-1); //2020-11-10 st 对应修改con的data和id
		 	$(this).attr("data",seat); 
		 	var seatY=parseInt($(this).attr('id').split("P")[1].split("T")[0])-1;
		 	if(seatY==0){seatY=1;}
		 	var seatId=seatX+"P"+seatY+"T"+(parseInt($(this).attr('id').split("T")[1])-1);
		 	$(this).attr("id",seatId); //ed
		}  
	});
	
	$("#line").find("path").each(function(){ //path
		var seatY=parseInt($(this).attr('id').split("P")[1]);
	    var seatX=parseInt($(this).attr('id').split("P")[0]); //2020-11-10
	    if(seatY>y1){
		 	seatD=$(this).attr('d'); //修改path的d
		 	seatDOne=seatD.split("C")[0]; //2020-11-10 st
		 	seatDTwo=seatD.split("C")[1];
		 	//alert($(this).attr('data')+"   "+seatD+"   "+parseInt(seatDOne.split(",")[1]))
		 	seatDataX=parseInt($(this).attr('data').split("P")[0]);
		 	seatDataY=parseInt($(this).attr('data').split("P")[1]);
		 	seatDataYEd=parseInt($(this).attr('data').split("P")[2]);
	     	if(seatDataY>y1){ //y起始大于当前y1,则-30,否则不变
				seatDOneNew=seatDOne.split(",")[0]+","+(parseInt(seatDOne.split(",")[1])-45); //原：30 2023-03-14样式修改
	     	}else{
		    	seatDOneNew=seatDOne;
		    }
		 	seatDY=seatDTwo.split(",")[5];
		 	seatDEndX=seatDTwo.split(",")[4]; //
		 	seatDYOld=","+seatDY;
		 	seatDYNew=","+(seatDY-45); //原：30 2023-03-14样式修改
		 	debugger;
		 	seatDTwoNew=seatDTwo.replaceAll(seatDYOld,seatDYNew);
		 	if(seatDY==seatDEndX){ //容错，当x足够大时
		 		seatDTwoNew=seatDTwoNew.split(",")[0]+","+seatDTwoNew.split(",")[1]+","+seatDTwoNew.split(",")[2]+","+seatDTwoNew.split(",")[3]+","+seatDEndX+","+seatDTwoNew.split(",")[5];
			}
		 	seatD=seatDOneNew+"C"+seatDTwoNew; //ed
		 	$(this).attr("d",seatD);
		 	
		 	var seat=seatX+"P"+(seatY-1); //2020-11-10 st 同步path的data和id
		 	$(this).attr("id",seat);
		 	var seat=seatDataX+"P"+(seatDataY-1)+"P"+(seatDataYEd-1);
			if(seatDataY<=y1){ //y起始小于当前y1,y起始不变
				var seat=seatDataX+"P"+seatDataY+"P"+(seatDataYEd-1);
			}
			$(this).attr("data",seat);  //ed
		}  
	});

}

///删除Con后需上移内容上移；
function resetHtmlByCon(x1,y1){
	//var str=x1+"Box"+y1;
	//if(!map.has(str)){
	$("#PathCon").find("div").each(function(){ //content
	  var seatY=parseInt($(this).attr('data').split("P")[1]);
	  var seatX=parseInt($(this).attr('data').split("P")[0]); //2020-11-09
	 	if(seatY>y1){
		 	seatT=$(this).css('top').split("px")[0]-45+"px"; //原：30 2023-03-14样式修改
		 	$(this).css("top",seatT);
		 	var seat=seatX+"P"+(seatY-1); //2020-11-09 st 对应修改con的data和id
		 	$(this).attr("data",seat); 
		 	var seatY=parseInt($(this).attr('id').split("P")[1].split("T")[0]);
		 	if(seatY>y1){seatY=seatY-1;} //y起始大于y1时，y起始-1
		 	var seatId=seatX+"P"+seatY+"T"+(parseInt($(this).attr('id').split("T")[1])-1);
		 	//alert(seatId)
		 	$(this).attr("id",seatId); //ed
		 }  
	});
		
	$("#PathLog").find(".PathLog").each(function(){ //logic
		var seatY=parseInt($(this).find("input").attr('id').split("Box")[1]);
		var seatX=parseInt($(this).find("input").attr('id').split("Box")[0]); //2020-11-09
	 	if(seatY>y1){
			seatT=$(this).css('top').split("px")[0]-45+"px"; //原：30 2023-03-14样式修改
		 	$(this).css("top",seatT);
		 	var seatId=seatX+"Box"+(seatY-1); //2020-11-09
		 	$(this).find("input").attr("id",seatId); //2020-11-09
		 	var type=$HUI.combobox("#"+seatId).getValue();
		 	displayCombobox(seatId,type); 
		 	
		 	//alert($("#"+seatId).attr("path")+"  ** "+seatId) //20201201 逻辑出身的对应修改st
			var pathNow=$("#"+seatId).attr("path");
		    var pathNowX=parseInt(pathNow.split("P")[0]);
		    var pathNowY=parseInt(pathNow.split("P")[1]);
		    var pathNowYEd=parseInt(pathNow.split("P")[2]);
		    if(pathNowY>y1){
				pathNowY=pathNowY-1;
			}
		    pathNowYEd=pathNowYEd-1;
		    pathNow=pathNowX+"P"+pathNowY+"P"+pathNowYEd;
		    $("#"+seatId).attr("path",pathNow);//ed
		 	
		}  
	});
		
	var pathStr="";
	$("#line").find("path").each(function(){ //path
		var seatX=parseInt($(this).attr('id').split("P")[0])
	    var seatY=parseInt($(this).attr('id').split("P")[1]);
	 	if(seatY>y1){
		 	if(pathStr==""){
			 	pathStr=$(this).attr('data');
			}else{
				pathStr=pathStr+"^"+$(this).attr('data');
			}
		 	$(this).remove();
		}  
	});
	//alert(pathStr);
	if(pathStr=="")return; //2020-11-09
	for(h=0;h<pathStr.split("^").length;h++){
		var seatXSt=pathStr.split("^")[h].split("P")[0];
    	var seatYSt=parseInt(pathStr.split("^")[h].split("P")[1]);
    	var seatYEd=parseInt(pathStr.split("^")[h].split("P")[2]);
		seatYStNew=seatYSt-1;
	    if(seatYSt<=y1){ 
		   seatYStNew=seatYSt;
		}
		if((seatYSt>y1)&&(seatYEd>y1)){
		   seatYStNew=seatYSt-1;
		}
	    seatYEdNew=seatYEd-1;
	    //alert(pathStr.split("^")[h]+"    -  "+seatXSt+", "+seatYStNew+", "+seatYEdNew)
        //alert(seatXSt+", "+seatYStNew+", "+seatYEdNew)
		displayPathAppend(seatXSt, seatYStNew, seatYEdNew,1);
	}
	///}else{
	//map.dalete(pathId);
 //}

}

///增加con或者logic后该下移内容下移 2020-11-11
function resetHtmlAdd(x1,y1){
	$("#PathLog").find(".PathLog").each(function(){ //logic
 		var seatX=parseInt($(this).find("input").attr('id').split("Box")[0]); 
		var seatY=parseInt($(this).find("input").attr('id').split("Box")[1]);
	 	if(seatY>y1){
		 	seatT=(parseInt($(this).css('top').split("px")[0])+45)+"px"; //原：30 2023-03-14样式修改
		 	$(this).css("top",seatT);
		 	
		 	var seatId=seatX+"Box"+(seatY+1); // 被下移逻辑id同步修改
			$(this).find("input:first").attr("id",seatId); //hxy 2021-04-13 add :first
			var type=$HUI.combobox("#"+seatId).getValue();
			displayCombobox(seatId,type); //ed
			 
			//alert($("#"+seatId).attr("path")+"  ** "+seatId) //20201201 逻辑出身的对应修改st
		    var pathNow=$("#"+seatId).attr("path");
		    var pathNowX=parseInt(pathNow.split("P")[0]);
		    var pathNowY=parseInt(pathNow.split("P")[1]);
		    var pathNowYEd=parseInt(pathNow.split("P")[2]);
		    if(pathNowY>y1){ //hxy 2021-04-13 >=改为>
				pathNowY=pathNowY+1;
			}
			pathNowYEd=pathNowYEd+1;
			pathNow=pathNowX+"P"+pathNowY+"P"+pathNowYEd;
			$("#"+seatId).attr("path",pathNow);//ed
		   
		}  
	});
	
	$("#PathCon").find("div").each(function(){ //content
		var seatX=parseInt($(this).attr('data').split("P")[0]);
		var seatY=parseInt($(this).attr('data').split("P")[1]);
	 	if(seatY>y1){
		 	seatT=(parseInt($(this).css('top').split("px")[0])+45)+"px"; //原：30 2023-03-14样式修改
		 	$(this).css("top",seatT);
		 	
		 	var seat=seatX+"P"+(seatY+1); //对应修改con的data和id
		 	$(this).attr("data",seat); 
		 	var seatY=parseInt($(this).attr('id').split("P")[1].split("T")[0])+1;
		 	var seatId=seatX+"P"+seatY+"T"+(parseInt($(this).attr('id').split("T")[1])+1);
		 	$(this).attr("id",seatId); //ed
		}  
	});

	$("#line").find("path").each(function(){ //path
		var seatX=parseInt($(this).attr('id').split("P")[0]);
	    var seatY=parseInt($(this).attr('id').split("P")[1]);
	    if(seatY>y1){
		 	seatD=$(this).attr('d'); //修改path的d
		 	seatDOne=seatD.split("C")[0]; //2020-11-10 st
		 	seatDTwo=seatD.split("C")[1];
		 	seatDataX=parseInt($(this).attr('data').split("P")[0]);
		 	seatDataY=parseInt($(this).attr('data').split("P")[1]);
		 	seatDataYEd=parseInt($(this).attr('data').split("P")[2]);
     		if(seatDataY>y1){ //y起始大于当前y1,则+30,否则不变
				seatDOneNew=seatDOne.split(",")[0]+","+(parseInt(seatDOne.split(",")[1])+45); //原：30 2023-03-14样式修改
     		}else{
	     		seatDOneNew=seatDOne;
	    	}
		 	seatDY=parseInt(seatDTwo.split(",")[5]);
		 	seatDEndX=seatDTwo.split(",")[4]; //
		 	seatDYOld=","+seatDY;
		 	seatDYNew=","+(seatDY+45);  //原：30 2023-03-14样式修改
		 	seatDTwoNew=seatDTwo.replaceAll(seatDYOld,seatDYNew);
		 	if(seatDY==seatDEndX){ //容错，当x足够大时
		 		seatDTwoNew=seatDTwoNew.split(",")[0]+","+seatDTwoNew.split(",")[1]+","+seatDTwoNew.split(",")[2]+","+seatDTwoNew.split(",")[3]+","+seatDEndX+","+seatDTwoNew.split(",")[5];
			}
		 	seatD=seatDOneNew+"C"+seatDTwoNew; //ed
		 	$(this).attr("d",seatD);
		 	
		 	var seat=seatX+"P"+(seatY+1); //st 同步path的data和id
		 	$(this).attr("id",seat);
		 	var seat=seatDataX+"P"+(seatDataY+1)+"P"+(seatDataYEd+1);
		 	if(seatDataY<=y1){ //y起始小于当前y1,y起始不变
				var seat=seatDataX+"P"+seatDataY+"P"+(seatDataYEd+1);
			}
		 	$(this).attr("data",seat);  //ed
		 }
	});

}

//请选择变量
function chooseVar(attr){
	attrsels = attr;
	AllUlPanel()
	var html = serverCall("web.DHCCKBRuleEditor","QueryDrugAttr",{}); //hxy 2022-05-24 变量模糊检索后，再次进入仍显示上次模糊检索的数据修改st
	$("#drugattr").html("");
	$("#drugattr").append(html);//ed
	$("#drugattr").css("display","block");
	$("#drugattr").css("left",$(attr).offset().left);
	$("#drugattr").css("top",$(attr).offset().top+$(attr).height());
	
}

//选择比较操作符面板浮现
function chooseOpera(Opera){
	AllUlPanel();
	//$(".dropdown-menu .dropdown-context").css("display","none");
	$("#operation").css("display","block");
	$("#operation").css("left",$(Opera).offset().left);
	$("#operation").css("top",$(Opera).offset().top+$(Opera).height());
	$(Opera).attr("id","OperaActive");
}

//输入值类型面板浮现
function chooseType(Type,value){
	AllUlPanel();
	$("#inputType").css("display","block");
	$("#inputType").css("left",$(Type).offset().left);
	$("#inputType").css("top",$(Type).offset().top+$(Type).height());
	$(Type).attr("id","TypeActive");
	
	var dataId = $(Type).prev().prev().attr("data_id");//2020-12-11 st
	var html = serverCall("web.DHCCKBRuleEditor","QueryDataHtmlByAttrFlag",{"attrId":dataId});//ed
	if(value==1){//2020-12-03 then/else只选输入值和数据集,原因：原图谱的输入单位、上下线不可用,且当前满足需要
		if(html!=""){
		/*$("#inputType").find("a[data='2']").css("display","none");
		$("#inputType").find("a[data='3']").css("display","none");
		$("#inputType").find("a[data='6']").css("display","none");
			$("#inputType").find("a[data='1']").css("display","none");
			$("#inputType").find("a[data='5']").css("display","block");*/
			TypeActive('I5'); //2020-12-17
		}else{
			/*$("#inputType").find("a[data='1']").css("display","block");
			$("#inputType").find("a[data='2']").css("display","none");
			$("#inputType").find("a[data='3']").css("display","none");
			$("#inputType").find("a[data='5']").css("display","none");
			$("#inputType").find("a[data='6']").css("display","none");*/
			TypeActive('I1'); //2020-12-17
		}
	}else{
		if($(Type).prev().attr("data")=="Between"){
			/*$("#inputType").find("a[data='3']").css("display","block");
			$("#inputType").find("a[data='1']").css("display","none");
			$("#inputType").find("a[data='2']").css("display","none");
			$("#inputType").find("a[data='5']").css("display","none");
			$("#inputType").find("a[data='6']").css("display","none");*/
			TypeActive('I3');
		}else{
			if(html!=""){
			 	/*$("#inputType").find("a[data='1']").css("display","none");
				$("#inputType").find("a[data='2']").css("display","none");
				$("#inputType").find("a[data='3']").css("display","none");
				$("#inputType").find("a[data='5']").css("display","block");
				$("#inputType").find("a[data='6']").css("display","none");*/
				TypeActive('I5'); //2020-12-17
			}else{
				if($(Type).prev().attr("data")=="Equals"){ //hxy 2022-05-17 st
					if($(Type).next().text()==""){ //hxy 2022-06-29 患者的体重-默认了带单位的，切换不了输入值（不显示选择的弹窗）
					TypeActive('I2'); 
					}
				}else{ //ed

				$("#inputType").find("a[data='2']").css("display","block");
				$("#inputType").find("a[data='3']").css("display","none"); //2020-12-18 block->none
				//$("#inputType").find("a[data='6']").css("display","block");
				$("#inputType").find("a[data='1']").css("display","block");
				$("#inputType").find("a[data='5']").css("display","none");//2020-12-18 block->none
				}
			}
		}
		
	}
	
}

//单位面板浮现
function chooseUnit(Unit){
	attrsels = Unit
	AllUlPanel();
	var dataId = serverCall("web.DHCCKBCommon","GetUnitData"); //hxy 2020-12-02 st
	var html = serverCall("web.DHCCKBRuleEditor","QueryDictonHtml",{"dicTionId":dataId,"q":""});
	$("#unit").html("")
	$("#unit").append(html);//ed
	$("#unit").css("display","block");
	$("#unit").css("left",$(Unit).offset().left);
	$("#unit").css("top",$(Unit).offset().top+$(Unit).height());
	$(Unit).attr("id","UnitActive");
	inputHide($("#UnitActive").prev()); //hxy 11-30 add(选择单位时，隐藏input) st 原来的UnitActive方法不被调用了
 	$(Unit).attr("id","");//ed
}

//规则面板浮现-(规则无,暂不处理)
function chooseRule(Rule){
	AllUlPanel();
	$("#rule").css("display","block");
	$("#rule").css("left",$(Rule).offset().left);
	$("#rule").css("top",$(Rule).offset().top+$(Rule).height());
	$(Rule).attr("id","RuleActive");
}

//比较操作符面板-选择触发
function OperaActive(Text,Value){ //20201126 add Value 
	if(Text=="Between"){
		$("#OperaActive").text("在");
		$("#OperaActive").next().next().next().html("<span class='line-red'><strong>之间</strong></span>")
	}else if(Text=="在集合"){
		$("#OperaActive").text("在集合");
		$("#OperaActive").next().next().next().html("<span class='line-red'><strong>之中</strong></span> ")
	}else{
		$("#OperaActive").text(Text);
		$("#OperaActive").next().next().next().html(""); //置空
	}
	$("#OperaActive").attr("data",Value); //20201126 add
	$("#OperaActive").next().next().html(""); //置空 11-16
	if(Text=="Between"){//2020-12-11 选择between时,直接默认选好上下线； st
		chooseType($("#OperaActive").next());
	}//ed
	if(Text=="等于"){//2022-05-17 选择等于时，默认好输入值(带单位)； st
		chooseType($("#OperaActive").next());
	}//ed
	$("#OperaActive").attr("id","");
	$("#operation").css("display","none");
}

//输入值类型面板-选择触发
function TypeActive(Text){
	var TextHtml="";
	if(Text=="I1"){//输入值
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>"
 		TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' value='' style='display: none;'>"
		$("#TypeActive").parent().parent().attr("data_type","Input");//20201130
	}
	if(Text=="I2"){//输入值(带单位)
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>"
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide(this)' style='display: none;'>"
	 	TextHtml=TextHtml+"<span class='line-blue' onclick='chooseUnit(this)'>请选择单位</span>"
	 	$("#TypeActive").parent().parent().attr("data_type","InputUom");//20201130
	}
	if(Text=="I3"){//输入值(上下线)
		TextHtml=	"<span class='line-brown' onclick='viewInput(this)'>请输入值</span>" //viewInput2
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide1(this)' style='display: none;'>"
	 	TextHtml=TextHtml+"<input class='hisui-validatebox textbox' data-options='' ondblclick='inputHide2(this)' onclick='inputHide1B2(this)'style='display: none;'>"
	 	TextHtml=TextHtml+"<span class='line-blue' onclick='chooseUnit(this)'>请选择单位</span>"
	 	$("#TypeActive").parent().parent().attr("data_type","InputLimit");//20201130
	}
	if(Text=="I4"){//选择变量
	}
	if(Text=="I5"){//选择数据集
		TextHtml="<span onmouseover='chooseDataset(this)' data_id='1' class='line-blue'>请选择数据集</span>"
		$("#TypeActive").parent().parent().attr("data_type","Constant");//20201130
	}
	if(Text=="I6"){//选择规则
		TextHtml=	"<span class='line-purple' onclick='chooseRule(this)'>请选择规则</span>"
	}
	if($("#TypeActive").prev().prev().text()=="请选择变量1"){
		$.messager.alert("提示:","请先选择变量！","info");
	}
	$("#TypeActive").next().html(TextHtml); //append
	$("#TypeActive").attr("id","");
	$("#inputType").css("display","none");
}

//单位面板-选择触发
function UnitActive(Unit){
	//alert($("#UnitActive").prev().val())
	inputHide($("#UnitActive").prev()); //11-16
	$("#UnitActive").text($(Unit).text());
	$("#UnitActive").attr("id","");
	$("#unit").css("display","none");	
}

//请输入值点击事件
function viewInput(Input){
	$(Input).next().css("display","inline");
	$(Input).css("display","none");
	var text=$(Input).text();
	if(text=="请输入值"){text="";}
	if($(Input).parent().find("input").length==2){
		$(Input).next().next().css("display","inline");
		text=text.replace("(","").replace(")","");
		$(Input).next().val(text.split("-")[0]);
		$(Input).next().next().val(text.split("-")[1]);
	}else{
		//$(Input).next().css("display","inline");
		//$(Input).css("display","none");
		//var text=$(Input).text();
	 	//if(text=="请输入值"){text="";}
	 	$(Input).next().val(text);
	}
	return;
}

//请输入值点击事件-上下线
function viewInput2(Input){
	$(Input).next().css("display","inline");
	$(Input).next().next().css("display","inline");
	$(Input).css("display","none");
	var text=$(Input).text();
	if(text=="请输入值"){text="";}
	text=text.replace("(","").replace(")","");
	$(Input).next().val(text.split("-")[0]);
	$(Input).next().next().val(text.split("-")[1]);
}

//输入值的input隐藏，变text
function inputHide(Hide){
	//alert($(Hide).parent().find("input").length)
	if($(Hide).parent().find("input").length==2){
		inputHide2(Hide);
	}else{
	$(Hide).css("display","none");
	$(Hide).prev().css("display","inline");
	if($(Hide).val()==""){ //2020-12-17 st
		$(Hide).prev().text("请输入值");
	}else{
	$(Hide).prev().text($(Hide).val());
	}//ed
	}
}

//输入值的input1隐藏，变text
function inputHide1(Hide){
	$(Hide).css("display","none");
	$(Hide).prev().css("display","inline");
	$(Hide).prev().text("("+$(Hide).val()+"-)");
}

//输入值的input2隐藏，变text
function inputHide2(Hide){
	$(Hide).css("display","none");
	$(Hide).prev().prev().css("display","inline");
	var text=$(Hide).prev().prev().text().split("-")[0]+"-"+$(Hide).val()+")";
	$(Hide).prev().prev().text(text);
}

//输入值的input1隐藏，变text,通过input2的单击
function inputHide1B2(Hide){
	$(Hide).prev().css("display","none");
	$(Hide).prev().prev().css("display","inline");
	$(Hide).prev().prev().text("("+$(Hide).prev().val()+"-)");
}

//隐藏所有ul弹窗面板
function AllUlPanel(){
	$("#operation").css("display","none");
	$("#inputType").css("display","none");
	$("#unit").css("display","none");
	$("#rule").css("display","none");
	$("#drugattr").css("display","none");
	$("#dataset").css("display","none");
	$("#TypeActive").attr("id",""); //2020-12-11 新增一个条件/动作，只选择到比较值符号，数据值类型只弹窗，未选择，再新增第二个条件/动作，选择数据集时到了第一个条件上；
	$("#OperaActive").attr("id",""); //2022-07-12 hxy 请选择变量1选择后自动默认等于默认时，偶发等于后的例如请选择数据集位置错误
	$("#manlevelattr").css("display","none");	// 2022-04-21 qnp
	ComboxOpHide(); //逻辑操作面板隐藏 2021-03-25
}

///属性面板的点击事件[公共-是否可以？]
function selItems(selObj)
{
	$(attrsels).attr('data_id',$(selObj).attr('data'));
	$(attrsels).attr('par_data',$(selObj).attr('par_data'));			//sufan 新增
	//$(attrsels).parent().parent().attr('data_cate',$(selObj).attr('par_data'));			//hxy 20201130 st 新增
	//$(attrsels).parent().parent().attr('data_name',$(selObj).attr('data'));			//ed
	var OldText=$(attrsels).html(); //hxy 2022-07-06 请选择变量1时才默认等于
	
	var name=$(selObj).attr('name');
	if(name==undefined){
		$(attrsels).html($(selObj).html())
		$(attrsels).parent().parent().attr('data_cate',$(selObj).attr('data')) //hxy 20201201  新增
		//if(OldText=="请选择变量1"){ //hxy 20202-07-06
		$(attrsels).next().attr("id","OperaActive"); //hxy 2022-06-28 st 请选择变量-选择后，自动默认比较符号为等于；
		OperaActive('等于','Equals'); //ed
		//}
	}else{
		
		$(attrsels).html(name+"的"+$(selObj).html())
		$(attrsels).parent().parent().attr('data_cate',$(selObj).attr('par_data'));	//hxy 20201201 st 新增
		$(attrsels).parent().parent().attr('data_name',$(selObj).attr('data'));		//ed
		var textStr=name+"的"+$(selObj).html();//hxy 2021-03-24 st
		//alert(textStr)
		if(textStr=="药品输出的通过标记"){
			selItemsAuto($(selObj).attr('data')); //自动选不通过
		}else{//ed
			//if((name!="药品输出")&&(OldText=="请选择变量1")){ //hxy 2022-07-06 //2022-07-21 add(name!="药品输出")
			//if(name!="药品输出"){
				$(attrsels).next().attr("id","OperaActive"); //hxy 2022-06-28 st 请选择变量-选择后，自动默认比较符号为等于；
				OperaActive('等于','Equals'); //ed
			//}
		}
	}
	AllUlPanel();
	
	if ($(selObj).text().indexOf("溶液")!=-1){
		$(attrsels).siblings(".manlevopeator").click();	
	};
}

///属性面板的点击事件[公共-是否可以？] -自动 hxy 2021-03-24
function selItemsAuto(data)
{
	var data_cate = serverCall("web.DHCCKBRuleEditor","QueryDataByAttr",{"attrId":data,"q":"不通过"}); //取值'不通过'的id
	$(attrsels).parent().parent().attr('data_type',"Constant"); //数据集
	$(attrsels).parent().attr('data_cate',data_cate);
	$(attrsels).next().next().next().html('<span onclick="chooseDataset(this)" data_id="'+data_cate+'" class="line-blue">不通过</span>')
}

///请选择数据集事件
function chooseDataset(dataset)
{
	attrsels = dataset
	AllUlPanel();
	var dataId = $(dataset).parent().prev().prev().prev().attr("data_id");
	
	var html = serverCall("web.DHCCKBRuleEditor","QueryDataHtmlByAttr",{"attrId":dataId});
	$("#dataset").html("");
	$("#dataset").append(html);
	$("#dataset").css("display","block");
	$("#dataset").css("left",$(dataset).offset().left);
	$("#dataset").css("top",$(dataset).offset().top+$(dataset).height());
	
	BindATips(); //hxy 2022-06-02
}

//保存
function saveRule(status){
	var status=status==undefined?"":status;
	//对于输入框，保存时，自动显示为预期效果（主要为了新增的保存）
	/*$("#line").find("input[value='']").each(function(){
		inputHide(this);
	})*/
	/* if(_dicStr.indexOf("^")==-1){
		$.messager.alert("提示","请选择目录！","info"); 
		return;
	} */
	//对于输入框，保存时，自动显示为预期效果（主要为了新增和修改的保存）
	$("#line").find("input[style='display: inline;']").each(function(){
		inputHide(this);
	})
	//提示:①请选择比较操作符！②输入值不能为空！③变量不能为空！④数据集不能为空！
	var len=$("#line").find("span:contains('请选择比较操作符')").length;
	if(len!=0){
		$.messager.alert("提示","请选择比较操作符！","info");
		return;
	}
	var len=$("#line").find("span:contains('请选择变量1')").length;
	if(len!=0){
		$.messager.alert("提示","变量不能为空！","info");
		return;
	}
	var len=$("#line").find("span:contains('请输入值')").length;
	if(len!=0){
		$.messager.alert("提示","输入值不能为空！","info");
		return;
	}
	var len=$("#line").find("span:contains('请选择数据集')").length;
	if(len!=0){
		$.messager.alert("提示","数据集不能为空！","info");
		return;
	}
	
	var len=$("#PathCon").find("div[data_type='']").length; //2020-12-14 st 空着输入值类型，发布后会影响审查结果，所以不能空
	if(len>0){
		var text=$("#PathCon").find("div[data_type='']").find(".line-darkcyan").text();
		$.messager.alert("提示","请选择 "+text+" 输入值类型！","info");
		return;
	}//ed
	
	//拼串st
	var savejson="",ifJson="",thenJson="",elseJson="";
	var logStringMap=new Map(); //20201125
	var map = new Map(); //202001124 ifLogNum map
 	ifJson=ifJson+'{'
 
 	var ruleJson=(function(){ //2020-11-23 递归 前台给后台json串 st
	  'use strict'
	  return  function fun(x,ifNumCur,ifLogNumCur,logStringCur,BoxIdCur,logLenCur,pathDataCur,y){
	  		var xx=x+1;
		    var ifNum="ifNum"+x; // 
      		ifNum=ifNumCur;
		    var ifLogNum="ifLogNum"+x+"#"+y; //+"#"+y 20201126
		    var keyStr=ifLogNum;
		    //alert(ifLogNum+"##"+x+"##"+y)
		    if(map.has(ifLogNum)){
			    ifLogNum=map.get(ifLogNum);
			    //alert(ifLogNum+"ifLogNum")
			   }else{
				   ifLogNum=0;
				  }
		    //ifLogNum=ifLogNumCur;
		    var logString="logString"+x+"#"+y; //
		    var logKeyStr=logString; //20201125 st
      		if(logStringMap.has(logKeyStr)){
			    logString=logStringMap.get(logKeyStr);
			}else{
				logString="";
			}//ed
		    //alert(logString)
		    //logString=logStringCur; //20201124 注释
		    var BoxId="BoxId"+xx;
		    BoxId=BoxIdCur;
		    var logLen="logLen"+x;
		    logLen=logLenCur;
			var logStr=xx+"Box"; //逻辑起始串
	 		var orLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='or'][path^='"+pathDataCur+"']").length;
      		var andLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='and'][path^='"+pathDataCur+"']").length;
      		var unionLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='union'][path^='"+pathDataCur+"']").length;
	 	  	ifLogNum=parseInt(ifLogNum)+1;
	 	  	map.set(keyStr,ifLogNum); //20201124
			var curLog=$HUI.combobox("#"+BoxId).getValue();//当前逻辑;
			//alert(logString+"*"+x+"*"+xx+"*"+BoxId+"*"+curLog)
			if(logString.indexOf(curLog)>-1){
				return "";
			}else{
				logString=logString+curLog;
				logStringMap.set(logKeyStr,logString); //20201124
			}
			//alert(logString+"  logStringNew")
			var curLogNum=curLog+"LogNum";
			if(curLogNum=="orLogNum"){
				curLogNum=orLogNum;
			}else if(curLogNum=="andLogNum"){
				curLogNum=andLogNum;
			}else{
				curLogNum=unionLogNum;
			}
			var flag=0;
		    if(curLogNum>1){
			  	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId).getValue()+'":[{' //第二层logic
			  	flag=1;
			}else if(curLogNum==1){
				ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId).getValue()+'":{' //第二层logic
			}					
			var number=0;
			$("#PathLog").find("input[id^='"+logStr+"'][data='"+curLog+"'][path^='"+pathDataCur+"']").each(function(){
				number=number+1;
				if((number!=1)&&(number=curLogNum))ifJson=ifJson+'},{'
				var ifNumNext="ifNum"+xx,ifLogNumNext="ifLogNum"+xx,logStringNext="logString"+xx; //
				var ifNumNext=0,ifLogNumNext=0;//内容个数计数,逻辑个数计数
         		var logStringNext="";//历史不重复的逻辑串
				var pathData=$(this).attr("id").replace("Box","P")+"P";
			 	var conData=$(this).attr("id").replace("Box","P")+"T";
			 	var pathLenNext="pathLen"+xx,conLenNext="conLen"+xx,logLenNext="logLen"+xx;//
			 	var pathLenNext=$("#line").find("path[data^='"+pathData+"']").length;
				var conLenNext=$("#PathCon").find("div[id^='"+conData+"']").length;
				var logLenNext=pathLenNext-conLenNext;
				//$("#line").find("path[data^='"+pathData+"']").each(function(){//20201126 st
				$("#PathCon").find("div[id^='"+conData+"']").each(function(){
					var ConId=$(this).attr("id");
					ifNumNext=ifNumNext+1;//是内容时+1
					if(ifNumNext==1){
						if(conLenNext>1){
							ifJson=ifJson+'"atom": ['
						}else if(conLenNext=1){
							ifJson=ifJson+'"atom": '
						}
					}
						
					var type=$("#"+ConId).attr("data_type"); //Constant 数据集st
					var rule=$("#"+ConId).attr("data_rule");
					var name=$("#"+ConId).attr("data_name");
					ifJson=ifJson+' {"left": {' 
					ifJson=ifJson+'  "_varCategory":"'+$("#"+ConId).find(".line-darkcyan").text().split("的")[0]+'",'
					ifJson=ifJson+'  "_ruleData":"'+$("#"+ConId).attr("data_rule")+'",'
					ifJson=ifJson+'  "_varCategoryId":"'+$("#"+ConId).attr("data_cate")+'",'
					//if((type!="Input")||(rule!=0)){ //20201202 st
					//if(rule!=0){ //ed //2020-12-10 注释
					if(name!=""){ //2020-12-10 add
					ifJson=ifJson+'  "_var":"'+$("#"+ConId).attr("data_name")+'",'
					var varLabel = $("#"+ConId).find(".line-darkcyan").text().split("的")[1];
					varLabel = varLabel == undefined?"":varLabel;
					ifJson=ifJson+'  "_varLabel":"'+varLabel+'",'
					//ifJson=ifJson+'  "_varLabel":"'+$("#"+ConId).find(".line-darkcyan").text().split("的")[1]+'",'
					ifJson=ifJson+'  "_datatype": "String",'
					}
					ifJson=ifJson+'  "_type": "variable"},'
					 
					ifJson=ifJson+'"value": {'
					ifJson=ifJson+'  "_ruleData":"'+$("#"+ConId).attr("data_rule")+'",'
					if(type=="Constant"){
						ifJson=ifJson+'  "_const-category":"'+$("#"+ConId).find(".line-blue").attr("data_id")+'",'
						ifJson=ifJson+'  "_const":"'+$("#"+ConId).find(".line-blue").attr("data_id")+'",'
						ifJson=ifJson+'  "_const-label":"'+$("#"+ConId).find(".line-blue").text()+'",'
					}else if(type=="InputUom"){
						//ifJson=ifJson+'  "_ruleData":"'+$("#"+ConId).attr("data_rule")+'",'
						ifJson=ifJson+'  "_content":"'+$("#"+ConId).find(".line-brown").text()+'",'
						ifJson=ifJson+'  "_uom":"'+$("#"+ConId).find(".line-blue").attr("data_id")+'",'
					}else if(type=="Input"){
						ifJson=ifJson+'  "_content":"'+$("#"+ConId).find(".line-brown").text()+'",'
					}else if(type=="InputLimit"){
						var content=$("#"+ConId).find(".line-brown").text();
						var conval = content.substring(1,content.length-1);
						ifJson=ifJson+'  "_content":"'+conval.split('-')[0]+'",'
						ifJson=ifJson+'  "_uom":"'+$("#"+ConId).find(".line-blue").attr("data_id")+'",'
						ifJson=ifJson+'  "_limit":"'+conval.split('-')[1]+'",'
					}
					var extconst = $("#"+ConId).find(".lineext-darkcyan").attr("data_id"); // 扩展的管理级别属性 2022-04-21 qnp
					extconst = extconst===undefined?"":extconst;
					var extconstvar = $("#"+ConId).find(".lineext-blue").attr("data_id");	// 扩展的管理级别-数据集  2022-04-21 qnp
					extconstvar = extconstvar===undefined?"":extconstvar;
					ifJson=ifJson+'  "_extconst":"'+extconst+'",'	
					ifJson=ifJson+'  "_extconstvar":"'+extconstvar+'",'	
								
					ifJson=ifJson+ '"_type":"'+type+'"},';
					/*var varCategoryId = $("#"+ConId).find(".line-darkcyan").attr("par_data");
					varCategoryId = varCategoryId == undefined?"":varCategoryId;
					var varCategory = $("#"+ConId).find(".line-darkcyan").attr("data_id");
					varCategory = varCategory == undefined?"":varCategory;
					var type = "variable";
					//组织left值
					if(varCategoryId==""){
						ifJson=ifJson+'"_varCategoryId":"'+varCategory+'",';
						ifJson=ifJson+'"_type":"'+type+'"},';
					}else{
						ifJson=ifJson+'"_varCategoryId":"'+varCategoryId+'",';
						ifJson=ifJson+'"_var":"'+varCategory+'",';
						ifJson=ifJson+'"_type":"'+type+'"},';
					}
					 
					ifJson=ifJson+'"value": {';
					if($("#"+ConId).find("input").length==0)
					{
						var constval = $("#"+ConId).find(".line-blue").attr("data_id");
						var type = "Constant";
						ifJson=ifJson+ '"_const":"'+constval+'",';
						ifJson=ifJson+ '"_type":"'+type+'"},';
					}else if($("#"+ConId).find("input").length==1){
						var content = $("#"+ConId).find(".line-brown").html();
						var uom = $("#"+ConId).find(".line-blue").attr("data_id");
						if(uom==undefined){
							var type = "Input";
							ifJson=ifJson+ '"_content":"'+content+'",';
						 	ifJson=ifJson+ '"_type":"'+type+'"},';
						}else{
							var type = "InputUom";
							ifJson=ifJson+ '"_content":"'+content+'",';
							ifJson=ifJson+ '"_uom":"'+uom+'",';
						 	ifJson=ifJson+ '"_type":"'+type+'"},';
						}
					}else{
						var content = $("#"+ConId).find(".line-brown").html();
						var uom = $("#"+ConId).find(".line-blue").attr("data_id");
						var type = "InputLimit";
						if(content.indexOf("-")>0){
							var conval = content.substring(1,content.length-1);
							var lowlimit = conval.split('-')[0];
							var upplimit = conval.split('-')[1];
							ifJson=ifJson+ '"_content":"'+lowlimit+'",';
							ifJson=ifJson+ '"_limit":"'+upplimit+'",';
							ifJson=ifJson+ '"_uom":"'+uom+'",';
						 	ifJson=ifJson+ '"_type":"'+type+'"},';
						}
					}//*/

					var op=$("#"+ConId).find(".line-red").attr("data");//20201126
					ifJson=ifJson+'"_op": "'+op+'"}'//ed
					if(ifNumNext<conLenNext)ifJson=ifJson+','
					if((ifNumNext==conLenNext)&&(conLenNext>1))ifJson=ifJson+']'
					if((ifNumNext==conLenNext)&&((ifNumNext<pathLenNext)))ifJson=ifJson+','
				})//20201126 ed
				$("#line").find("path[data^='"+pathData+"']").each(function(){
					var data=$(this).attr("data");
					var x=parseInt(data.split("P")[0]);
					var y=parseInt(data.split("P")[1]);
					var yEd=parseInt(data.split("P")[2]);
					var ConId=x+"P"+y+"T"+yEd;
					var BoxIdNext="BoxId"+(x+1);
					BoxIdNext=(x+1)+"Box"+yEd;
					var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
					/*if(con>0){//是内容
							ifNumNext=ifNumNext+1;//是内容时+1
							if(ifNumNext==1){
									if(conLenNext>1){
										ifJson=ifJson+'"atom": ['
									}else if(conLenNext=1){
										ifJson=ifJson+'"atom": '
									}
							}
							ifJson=ifJson+' {"left": {},' //Constant 数据集st
							ifJson=ifJson+'"value": {},'
							var op=$("#"+ConId).find(".line-red").attr("data");//20201126
							ifJson=ifJson+'"_op": "'+op+'"}'//ed
							if(ifNumNext<conLenNext)ifJson=ifJson+','
							if((ifNumNext==conLenNext)&&(ifNumNext!=1))ifJson=ifJson+']'
							if((ifNumNext==conLenNext)&&((ifNumNext<pathLenNext)))ifJson=ifJson+','
					}else{//是逻辑第四层st*/
					if(con<1){
            	 		var rtnStr=fun(x,ifNumNext,ifLogNumNext,logStringNext,BoxIdNext,logLenNext,pathData,y);		
											 
					}//第四层是逻辑ed
				})
			})

	     ifJson=ifJson+'}'
	     if(flag==1)ifJson=ifJson+']' 
	     //alert(ifLogNum+"***"+logLen)
	     if((orLogNum!=logLen)&&(andLogNum!=logLen)&&(unionLogNum!=logLen)){//20201127 只有一层逻辑时，不必逗号
	     if(ifLogNum<logLen)ifJson=ifJson+','
	     }
	     //return logString+"^"+ifLogNum;
	  }   
	})()
	var getRuleJson=ruleJson; //ed
 
	//var elseNum=0;
 	var pathData="1P1P",conData="1P1T",BoxId="1Box1";
 	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId).getValue()+'":{' //第一个logic
 	var pathLen=$("#line").find("path[data^='"+pathData+"']").length;
 	var conLen=$("#PathCon").find("div[id^='"+conData+"']").length;
 	var logLen=pathLen-conLen;
 	var logStr="2Box"; ////逻辑ID串
 	var orLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='or']").length;
	var andLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='and']").length;
	var unionLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='union']").length;
 	var ifNum=0,ifLogNum=0;//内容计数，逻辑计数
 	var logString=""; //历史逻辑，不重复
 
 	//$("#line").find("path[data^='"+pathData+"']").each(function(){ //20201126 st
 	$("#PathCon").find("div[id^='"+conData+"']").each(function(){
		var ConId=$(this).attr("id");
		ifNum=ifNum+1;//是内容时+1
		if(ifNum==1){
			if(conLen>1){
				ifJson=ifJson+'"atom": ['
			}else if(conLen=1){
				ifJson=ifJson+'"atom": '
			}
		}
			
		var type=$("#"+ConId).attr("data_type");//Constant 数据集st
		var rule=$("#"+ConId).attr("data_rule");
		var name=$("#"+ConId).attr("data_name");
		ifJson=ifJson+' {"left": {' 
		ifJson=ifJson+'  "_varCategory":"'+$("#"+ConId).find(".line-darkcyan").text().split("的")[0]+'",'
		ifJson=ifJson+'  "_ruleData":"'+$("#"+ConId).attr("data_rule")+'",'
		ifJson=ifJson+'  "_varCategoryId":"'+$("#"+ConId).attr("data_cate")+'",'
		//if((type!="Input")||(rule!=0)){ //20201202 st
		//if(rule!=0){ //ed //2020-12-10 注释
		if(name!=""){ //2020-12-10 add
		ifJson=ifJson+'  "_var":"'+$("#"+ConId).attr("data_name")+'",'
		var varLabel = $("#"+ConId).find(".line-darkcyan").text().split("的")[1];
		varLabel = varLabel == undefined?"":varLabel;
		ifJson=ifJson+'  "_varLabel":"'+varLabel+'",'
		ifJson=ifJson+'  "_datatype": "String",'
		}
		ifJson=ifJson+'  "_type": "variable"},'
		 
		ifJson=ifJson+'"value": {'
		ifJson=ifJson+'  "_ruleData":"'+$("#"+ConId).attr("data_rule")+'",'
		if(type=="Constant"){
			ifJson=ifJson+'  "_const-category":"'+$("#"+ConId).find(".line-blue").attr("data_id")+'",'
			ifJson=ifJson+'  "_const":"'+$("#"+ConId).find(".line-blue").attr("data_id")+'",'
			ifJson=ifJson+'  "_const-label":"'+$("#"+ConId).find(".line-blue").text()+'",'
		}else if(type=="InputUom"){
			//ifJson=ifJson+'  "_ruleData":"'+$("#"+ConId).attr("data_rule")+'",'
    	ifJson=ifJson+'  "_content":"'+$("#"+ConId).find(".line-brown").text()+'",'
    	ifJson=ifJson+'  "_uom":"'+$("#"+ConId).find(".line-blue").attr("data_id")+'",'
		}else if(type=="Input"){
			ifJson=ifJson+'  "_content":"'+$("#"+ConId).find(".line-brown").text()+'",'
		}else if(type=="InputLimit"){
			var content=$("#"+ConId).find(".line-brown").text();
			var conval = content.substring(1,content.length-1);
			ifJson=ifJson+'  "_content":"'+conval.split('-')[0]+'",'
			ifJson=ifJson+'  "_uom":"'+$("#"+ConId).find(".line-blue").attr("data_id")+'",'
			ifJson=ifJson+'  "_limit":"'+conval.split('-')[1]+'",'
		}
		var extconst = $("#"+ConId).find(".lineext-darkcyan").attr("data_id"); // 扩展的管理级别属性 2022-04-21 qnp
		extconst = extconst===undefined?"":extconst;
		var extconstvar = $("#"+ConId).find(".lineext-blue").attr("data_id");	// 扩展的管理级别-数据集  2022-04-21 qnp
		extconstvar = extconstvar===undefined?"":extconstvar;
		ifJson=ifJson+'  "_extconst":"'+extconst+'",'	
		ifJson=ifJson+'  "_extconstvar":"'+extconstvar+'",'		
		ifJson=ifJson+ '"_type":"'+type+'"},';
		/*var varCategoryId = $("#"+ConId).find(".line-darkcyan").attr("par_data"); //Constant 数据集st
		varCategoryId = varCategoryId == undefined?"":varCategoryId;
		var varCategory = $("#"+ConId).find(".line-darkcyan").attr("data_id");
		varCategory = varCategory == undefined?"":varCategory;
		var type = "variable";
		//组织left值
		ifJson=ifJson+' {"left": {'
		if(varCategoryId==""){
			ifJson=ifJson+'"_varCategoryId":"'+varCategory+'",';
			ifJson=ifJson+'"_type":"'+type+'"},';
		}else{
			ifJson=ifJson+'"_varCategoryId":"'+varCategoryId+'",';
			ifJson=ifJson+'"_var":"'+varCategory+'",';
			ifJson=ifJson+'"_type":"'+type+'"},';
		}		 
		ifJson=ifJson+'"value": {'
		if($("#"+ConId).find("input").length==0)
		{
			var constval = $("#"+ConId).find(".line-blue").attr("data_id");
			var type = "Constant";
			ifJson=ifJson+ '"_const":"'+constval+'",';
			ifJson=ifJson+ '"_type":"'+type+'"},';
		}else if($("#"+ConId).find("input").length==1){
			var content = $("#"+ConId).find(".line-brown").html();
			var uom = $("#"+ConId).find(".line-blue").attr("data_id");
			if(uom==undefined){
				var type = "Input";
				ifJson=ifJson+ '"_content":"'+content+'",';
			 	ifJson=ifJson+ '"_type":"'+type+'"},';
			}else{
				var type = "InputUom";
				ifJson=ifJson+ '"_content":"'+content+'",';
				ifJson=ifJson+ '"_uom":"'+uom+'",';
			 	ifJson=ifJson+ '"_type":"'+type+'"},';
			}
		}else{
			var content = $("#"+ConId).find(".line-brown").html();
			var uom = $("#"+ConId).find(".line-blue").attr("data_id");
			var type = "InputLimit";
			if(content.indexOf("-")>0){
				var conval = content.substring(1,content.length-1);
				var lowlimit = conval.split('-')[0];
				var upplimit = conval.split('-')[1];
				ifJson=ifJson+ '"_content":"'+lowlimit+'",';
				ifJson=ifJson+ '"_limit":"'+upplimit+'",';
				ifJson=ifJson+ '"_uom":"'+uom+'",';
			 	ifJson=ifJson+ '"_type":"'+type+'"},';
			}
		}//ed*/
		 
		var op=$("#"+ConId).find(".line-red").attr("data");//20201126  
		ifJson=ifJson+'"_op": "'+op+'"}'//ed
		if(ifNum<conLen)ifJson=ifJson+','
		if((ifNum==conLen)&&(conLen>1))ifJson=ifJson+']'
   		if((ifNum==conLen)&&(ifNum<pathLen))ifJson=ifJson+','
 	})//20201126 ed
 
	$("#line").find("path[data^='"+pathData+"']").each(function(){
		var data=$(this).attr("data");
	 	var x=parseInt(data.split("P")[0]);
	 	var y=parseInt(data.split("P")[1]);
	 	var yEd=parseInt(data.split("P")[2]);
	 	var ConId=x+"P"+y+"T"+yEd;
	 	var BoxId2=(x+1)+"Box"+yEd;
	 	var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
	 	/*if(con>0){//是内容
			 ifNum=ifNum+1;//是内容时+1
			 if(ifNum==1){
					 if(conLen>1){
						 ifJson=ifJson+'"atom": ['
						}else if(conLen=1){
							ifJson=ifJson+'"atom": '
						}
				}
			 var varCategoryId = $("#"+ConId).find(".line-darkcyan").attr("par_data");
			 varCategoryId = varCategoryId == undefined?"":varCategoryId;
			 var varCategory = $("#"+ConId).find(".line-darkcyan").attr("data_id");
			 varCategory = varCategory == undefined?"":varCategory;
			 var type = "variable";
			 //组织left值
			 ifJson=ifJson+' {"left": {'
			 if(varCategoryId==""){
				 ifJson=ifJson+'"_varCategoryId":"'+varCategory+'",';
				 ifJson=ifJson+'"_type":"'+type+'"},';
			 }else{
				 ifJson=ifJson+'"_varCategoryId":"'+varCategoryId+'",';
				 ifJson=ifJson+'"_var":"'+varCategory+'",';
				 ifJson=ifJson+'"_type":"'+type+'"},';
			 }
			 
			 //Constant 数据集st
			 
			 ifJson=ifJson+'"value": {},'
			 var op=$("#"+ConId).find(".line-red").attr("data");//20201126
			 ifJson=ifJson+'"_op": "'+op+'"}'//ed
			 if(ifNum<conLen)ifJson=ifJson+','
			 if((ifNum==conLen)&&(conLen>1))ifJson=ifJson+']'
    		if((ifNum==conLen)&&(ifNum<pathLen))ifJson=ifJson+','
   
		}else{//是逻辑1st*/
	 	if(con<1){
     		rtnStr=getRuleJson(x,ifNum,ifLogNum,logString,BoxId2,logLen,pathData,y); //ifLogNumCur,logStringCur==（ifLogNum,logString） 这俩参数理论上不再需要
			  /*ifLogNum=ifLogNum+1;
			  var curLog=$HUI.combobox("#"+BoxId2).getValue();//当前逻辑;
			  if(logString.indexOf(curLog)>-1){
				  return true;
			  }else{
						logString=logString+curLog;
			  }
			  var curLogNum=curLog+"LogNum";
			  if(curLogNum=="orLogNum"){
				  curLogNum=orLogNum;
				 }else if(curLogNum=="andLogNum"){
					 curLogNum=andLogNum;
					}else{
						curLogNum=unionLogNum;
					}
			  var flag=0;
			  if(curLogNum>1){
				  	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId2).getValue()+'":[{' //第二层logic
				  	flag=1;
				 }else if(curLogNum==1){
					 	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId2).getValue()+'":{' //第二层logic
					}					
		   	  var number=0;//该逻辑个数计数
					$("#PathLog").find("input[id^='"+logStr+"'][data='"+curLog+"']").each(function(){
						  number=number+1;
						  if((number!=1)&&(number=curLogNum))ifJson=ifJson+'},{'
						  var ifNum2=0,ifLogNum2=0;//内容个数计数,逻辑个数计数
						  var logString2="";//历史不重复的逻辑串
						 	var pathData=$(this).attr("id").replace("Box","P")+"P";
						 	var conData=$(this).attr("id").replace("Box","P")+"T";
						 	var pathLen2=$("#line").find("path[data^='"+pathData+"']").length;
						  var conLen2=$("#PathCon").find("div[id^='"+conData+"']").length;
						  var logLen2=pathLen2-conLen2;
						  $("#line").find("path[data^='"+pathData+"']").each(function(){
										 var data=$(this).attr("data");
										 var x=parseInt(data.split("P")[0]);
										 var y=parseInt(data.split("P")[1]);
										 var yEd=parseInt(data.split("P")[2]);
										 var ConId=x+"P"+y+"T"+yEd;
										 var BoxId3=(x+1)+"Box"+yEd;
										 var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
										 if(con>0){//是内容
												 ifNum2=ifNum2+1;//是内容时+1
												 if(ifNum2==1){
														 if(conLen2>1){
															 ifJson=ifJson+'"atom": ['
															}else if(conLen2=1){
																ifJson=ifJson+'"atom": '
															}
													}
												 ifJson=ifJson+' {"left": {},' //Constant 数据集st
													ifJson=ifJson+'"value": {},'
													var op=$("#"+ConId).find(".line-red").attr("data");//20201126
													ifJson=ifJson+'"_op": "'+op+'"}'//ed
													if(ifNum2<conLen2)ifJson=ifJson+','
													if((ifNum2==conLen2)&&(ifNum2!=1))ifJson=ifJson+']'
													if((ifNum2==conLen2)&&((ifNum2<pathLen2)))ifJson=ifJson+','
										 }else{//是逻辑2st
										     //alert("fun"+ConId)
										     rtnStr=getRuleJson(x,ifNum2,ifLogNum2,logString2,BoxId3,logLen2,pathData,y); //ifLogNumCur,logStringCur==（ifLogNum2,logString2） 这俩参数理论上不再需要
										 				/*var logStr=(x+1)+"Box"; //
										 				var orLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='or']").length;
	              								var andLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='and']").length;
	              								var unionLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='union']").length;
										 	  	ifLogNum2=ifLogNum2+1;
													  var curLog=$HUI.combobox("#"+BoxId3).getValue();//当前逻辑;
													  if(logString2.indexOf(curLog)>-1){
														  return true;
													  }else{
																logString2=logString2+curLog;
													  }
													  var curLogNum=curLog+"LogNum";
													  if(curLogNum=="orLogNum"){
														  curLogNum=orLogNum;
														 }else if(curLogNum=="andLogNum"){
															 curLogNum=andLogNum;
															}else{
																curLogNum=unionLogNum;
															}
													  var flag=0;
													  if(curLogNum>1){
														  	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId3).getValue()+'":[{' //第二层logic
														  	flag=1;
														 }else if(curLogNum==1){
															 	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId3).getValue()+'":{' //第二层logic
															}					
												   		var number=0;
															$("#PathLog").find("input[id^='"+logStr+"'][data='"+curLog+"']").each(function(){
																  number=number+1;
																  if((number!=1)&&(number=curLogNum))ifJson=ifJson+'},{'
																  var ifNum3=0,ifLogNum3=0;//内容个数计数,逻辑个数计数
																		var logString3="";//历史不重复的逻辑串
																 	var pathData=$(this).attr("id").replace("Box","P")+"P";
																 	var conData=$(this).attr("id").replace("Box","P")+"T";
																 	var pathLen3=$("#line").find("path[data^='"+pathData+"']").length;
																  var conLen3=$("#PathCon").find("div[id^='"+conData+"']").length;
																  var logLen3=pathLen3-conLen3;
																  $("#line").find("path[data^='"+pathData+"']").each(function(){
																				 var data=$(this).attr("data");
																				 var x=parseInt(data.split("P")[0]);
																				 var y=parseInt(data.split("P")[1]);
																				 var yEd=parseInt(data.split("P")[2]);
																				 var ConId=x+"P"+y+"T"+yEd;
																				 var BoxId4=(x+1)+"Box"+yEd;
																				 var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
																				 if(con>0){//是内容
																						 ifNum3=ifNum3+1;//是内容时+1
																						 if(ifNum3==1){
																								 if(conLen3>1){
																									 ifJson=ifJson+'"atom": ['
																									}else if(conLen3=1){
																										ifJson=ifJson+'"atom": '
																									}
																							}
																						 ifJson=ifJson+' {"left": {},' //Constant 数据集st
																							ifJson=ifJson+'"value": {},'
																							ifJson=ifJson+'"_op": "Equals"}'//ed
																							if(ifNum3<conLen3)ifJson=ifJson+','
																							if((ifNum3==conLen3)&&(ifNum3!=1))ifJson=ifJson+']'
																							if((ifNum3==conLen3)&&((ifNum3<pathLen3)))ifJson=ifJson+','
																				 }else{//是逻辑第三层st
																				 				//rtnStr=getRuleJson(x,ifNum3,ifLogNum3,logString3,BoxId4,logLen3);
																				 				//logString3=rtnStr.split("^")[0];
										               											//ifLogNum3=rtnStr.split("^")[1];
																				 				var logStr=(x+1)+"Box"; //
																				 				var orLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='or']").length;
											              										var andLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='and']").length;
											              										var unionLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='union']").length;
																				 	  			ifLogNum3=ifLogNum3+1;
																							  var curLog=$HUI.combobox("#"+BoxId4).getValue();//当前逻辑;
																							  if(logString3.indexOf(curLog)>-1){
																								  return true;
																							  }else{
																										logString3=logString3+curLog;
																							  }
																							  var curLogNum=curLog+"LogNum";
																							  if(curLogNum=="orLogNum"){
																								  curLogNum=orLogNum;
																								 }else if(curLogNum=="andLogNum"){
																									 curLogNum=andLogNum;
																									}else{
																										curLogNum=unionLogNum;
																									}
																							  var flag=0;
																							  if(curLogNum>1){
																								  	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId4).getValue()+'":[{' //第二层logic
																								  	flag=1;
																								 }else if(curLogNum==1){
																									 	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId4).getValue()+'":{' //第二层logic
																									}					
																						   var number=0;
																									$("#PathLog").find("input[id^='"+logStr+"'][data='"+curLog+"']").each(function(){
																										  number=number+1;
																										  if((number!=1)&&(number=curLogNum))ifJson=ifJson+'},{'
																										  var ifNum4=0,ifLogNum4=0;//内容个数计数,逻辑个数计数
																		          							var logString4="";//历史不重复的逻辑串
																										 	var pathData=$(this).attr("id").replace("Box","P")+"P";
																										 	var conData=$(this).attr("id").replace("Box","P")+"T";
																										 	var pathLen4=$("#line").find("path[data^='"+pathData+"']").length;
																										  var conLen4=$("#PathCon").find("div[id^='"+conData+"']").length;
																										  var logLen4=pathLen4-conLen4;
																										  $("#line").find("path[data^='"+pathData+"']").each(function(){
																														 var data=$(this).attr("data");
																														 var x=parseInt(data.split("P")[0]);
																														 var y=parseInt(data.split("P")[1]);
																														 var yEd=parseInt(data.split("P")[2]);
																														 var ConId=x+"P"+y+"T"+yEd;
																														 var BoxId5=(x+1)+"Box"+yEd;
																														 var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
																														 if(con>0){//是内容
																																 ifNum4=ifNum4+1;//是内容时+1
																																 if(ifNum4==1){
																																		 if(conLen4>1){
																																			 ifJson=ifJson+'"atom": ['
																																			}else if(conLen4=1){
																																				ifJson=ifJson+'"atom": '
																																			}
																																	}
																																 ifJson=ifJson+' {"left": {},' //Constant 数据集st
																																	ifJson=ifJson+'"value": {},'
																																	ifJson=ifJson+'"_op": "Equals"}'//ed
																																	if(ifNum4<conLen4)ifJson=ifJson+','
																																	if((ifNum4==conLen4)&&(ifNum4!=1))ifJson=ifJson+']'
																																	if((ifNum4==conLen4)&&((ifNum4<pathLen4)))ifJson=ifJson+','
																														 }else{//是逻辑第四层st
																														   //alert(pathData+"pathData")
																														 	 var logStr=(x+1)+"Box"; //
																												 				var orLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='or'][path^='"+pathData+"']").length;
																			              										var andLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='and'][path^='"+pathData+"']").length;
																			              									var unionLogNum=$("#PathLog").find("input[id^='"+logStr+"'][data='union'][path^='"+pathData+"']").length;
																												 	  		ifLogNum4=ifLogNum4+1;
																															  var curLog=$HUI.combobox("#"+BoxId5).getValue();//当前逻辑;
																															  if(logString4.indexOf(curLog)>-1){
																																  return true;
																															  }else{
																																		logString4=logString4+curLog;
																															  }
																															  var curLogNum=curLog+"LogNum";
																															  if(curLogNum=="orLogNum"){
																																  curLogNum=orLogNum;
																																 }else if(curLogNum=="andLogNum"){
																																	 curLogNum=andLogNum;
																																	}else{
																																		curLogNum=unionLogNum;
																																	}
																															  var flag=0;
																															  if(curLogNum>1){
																																  	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId5).getValue()+'":[{' //logic
																																  	flag=1;
																																 }else if(curLogNum==1){
																																	 	ifJson=ifJson+'"'+$HUI.combobox("#"+BoxId5).getValue()+'":{' //logic
																																	}					
																														   var number=0;
																																	$("#PathLog").find("input[id^='"+logStr+"'][data='"+curLog+"'][path^='"+pathData+"']").each(function(){
																																		  number=number+1;
																																		  if((number!=1)&&(number=curLogNum))ifJson=ifJson+'},{'
																																		  var ifNum5=0,ifLogNum5=0;//内容个数计数,逻辑个数计数
																										          							var logString5="";//历史不重复的逻辑串
																																		 	var pathData=$(this).attr("id").replace("Box","P")+"P";
																																		 	var conData=$(this).attr("id").replace("Box","P")+"T";
																																		 	var pathLen5=$("#line").find("path[data^='"+pathData+"']").length;
																																		  var conLen5=$("#PathCon").find("div[id^='"+conData+"']").length;
																																		  var logLen5=pathLen5-conLen5;
																																		  $("#line").find("path[data^='"+pathData+"']").each(function(){
																																						 var data=$(this).attr("data");
																																						 var x=parseInt(data.split("P")[0]);
																																						 var y=parseInt(data.split("P")[1]);
																																						 var yEd=parseInt(data.split("P")[2]);
																																						 var ConId=x+"P"+y+"T"+yEd;
																																						 //alert(ConId)
																																						 var BoxId6=(x+1)+"Box"+yEd;
																																						 var con=$("#PathCon").find("#"+ConId).length; //当前path是不是内容 ==1 >0
																																						 if(con>0){//是内容
																																								 ifNum5=ifNum5+1;//是内容时+1
																																								 if(ifNum5==1){
																																										 if(conLen5>1){
																																											 ifJson=ifJson+'"atom": ['
																																											}else if(conLen5=1){
																																												ifJson=ifJson+'"atom": '
																																											}
																																									}
																																								 ifJson=ifJson+' {"left": {},' //Constant 数据集st
																																									ifJson=ifJson+'"value": {},'
																																									ifJson=ifJson+'"_op": "Equals"}'//ed
																																									if(ifNum5<conLen5)ifJson=ifJson+','
																																									if((ifNum5==conLen5)&&(ifNum5!=1))ifJson=ifJson+']'
																																									if((ifNum5==conLen5)&&((ifNum5<pathLen5)))ifJson=ifJson+','
																																						 }else{//是逻辑第五层st
																																						 	  																																			 	  
																																						 	  
																																						 
																																				   }//第五层是逻辑ed
																																	   })
																																 })

																												     ifJson=ifJson+'}'
																												     if(flag==1)ifJson=ifJson+']' 
																												     if(ifLogNum4<logLen4)ifJson=ifJson+',' 
																														 
																												   }//第四层是逻辑ed
																									   })
																								 })

																				     ifJson=ifJson+'}'
																				     if(flag==1)ifJson=ifJson+']' 
																				     if(ifLogNum3<logLen3)ifJson=ifJson+',' 

																		   }//第三层是逻辑ed 
															   })
														 })

										     ifJson=ifJson+'}'
										     if(flag==1)ifJson=ifJson+']' 
										     if(ifLogNum2<logLen2)ifJson=ifJson+','  //*/
			  /*							     
								   }//第二层是逻辑ed
					   })
				 })

     ifJson=ifJson+'}'
     if(flag==1)ifJson=ifJson+']' 
     if(ifLogNum<logLen)ifJson=ifJson+',' //*/
	 }//第一层是逻辑ed
		
	})//each1 ed
	ifJson=ifJson+'}' //第一个logic结束
	ifJson=ifJson+'}' //if结束 //ifJson=ifJson+'},' //if结束
	//alert(ifJson)
	console.log(ifJson)
	//return; //
	
	var thenNum=0,thenLen=$("#then").find(".rule-action").length;
	var flagStr="";//选择变量不正确标志,必须 *的*
	$("#then>.rule-action").each(function(){ //then
		thenNum=thenNum+1;
		//alert($(this).attr("id"))
		var ruleData=$(this).attr("id");//2020-12-03 st
		if($(this).find(".line-brown").length>0){
			thenJson=thenJson+'{"value":{"_ruleData":"0",'
			var content=$(this).find(".line-brown").text();
			thenJson=thenJson+'"_content":"'+content+'",'
			thenJson=thenJson+'"_type":"Input"},'
		}else{
			thenJson=thenJson+'{"value":{'
			thenJson=thenJson+'"_ruleData":"'+$(this).attr("id")+'",'
			thenJson=thenJson+'"_const-category":"undefined",'
			thenJson=thenJson+'"_const":"'+$(this).find(".line-blue").attr("data_id")+'",'
			thenJson=thenJson+'"_const-label":"'+$(this).find(".line-blue").text()+'",'
			thenJson=thenJson+'"_type":"Constant"},'
		}
		var pardata=$(this).find(".line-darkcyan-zero").attr("par_data");
		if(pardata==""){
			flagStr=$(this).find(".line-darkcyan-zero").text().split("的")[0];
			return false
		}
		thenJson=thenJson+'"_varCategory":"'+$(this).find(".line-darkcyan-zero").text().split("的")[0]+'",'
		thenJson=thenJson+'"_ruleData":"'+$(this).attr("id")+'",'
		thenJson=thenJson+'"_varCategoryId":"'+$(this).find(".line-darkcyan-zero").attr("par_data")+'",'
		thenJson=thenJson+'"_var":"'+$(this).find(".line-darkcyan-zero").attr("data_id")+'",'
		thenJson=thenJson+'"_varLabel":"'+$(this).find(".line-darkcyan-zero").text().split("的")[1]+'",'
		if(ruleData==0){
			thenJson=thenJson+'"_datatype":"String",'
		}else{
		thenJson=thenJson+'"_datatype":"undefined",'
		}
		thenJson=thenJson+'"_type":"variable"}'
		if(thenNum!=thenLen){
			thenJson=thenJson+','
		}
	});
	if(flagStr!=""){
		$.messager.alert("提示","“变量赋值”动作【"+flagStr+"】下未选择具体属性，该动作只能针对具体变量下的属性进行赋值，不能对变量本身进行赋值!","info");
		return;
	}
	if(thenJson!=""){
		thenJson='{"var-assign":['+thenJson+']}'
	}
	//alert(thenJson)
	var elseNum=0,elseLen=$("#else").find(".rule-action").length;
	var flagStr=""
 	$("#else>.rule-action").each(function(){ //else
		elseNum=elseNum+1;
		var ruleData=$(this).attr("id");//2020-12-03 st
		if($(this).find(".line-brown").length>0){
			elseJson=elseJson+'{"value":{"_ruleData":"0",'
			var content=$(this).find(".line-brown").text();
			elseJson=elseJson+'"_content":"'+content+'",'
			elseJson=elseJson+'"_type":"Input"},'
		}else{
			elseJson=elseJson+'{"value":{'
			elseJson=elseJson+'"_ruleData":"'+$(this).attr("id")+'",'
			elseJson=elseJson+'"_const-category":"undefined",'
			elseJson=elseJson+'"_const":"'+$(this).find(".line-blue").attr("data_id")+'",'
			elseJson=elseJson+'"_const-label":"'+$(this).find(".line-blue").text()+'",'
			elseJson=elseJson+'"_type":"Constant"},'
		}
		var pardata=$(this).find(".line-darkcyan-zero").attr("par_data");
		if(pardata==""){
			flagStr=$(this).find(".line-darkcyan-zero").text().split("的")[0];
			return false
		}
		elseJson=elseJson+'"_varCategory":"'+$(this).find(".line-darkcyan-zero").text().split("的")[0]+'",'
		elseJson=elseJson+'"_ruleData":"'+$(this).attr("id")+'",'
		elseJson=elseJson+'"_varCategoryId":"'+$(this).find(".line-darkcyan-zero").attr("par_data")+'",'
		elseJson=elseJson+'"_var":"'+$(this).find(".line-darkcyan-zero").attr("data_id")+'",'
		elseJson=elseJson+'"_varLabel":"'+$(this).find(".line-darkcyan-zero").text().split("的")[1]+'",'
		if(ruleData==0){
			elseJson=elseJson+'"_datatype":"String",'
		}else{
		elseJson=elseJson+'"_datatype":"undefined",'
		}
		elseJson=elseJson+'"_type":"variable"}'
		if(elseNum!=elseLen){
			elseJson=elseJson+','
		}
	});
	if(flagStr!=""){
		$.messager.alert("提示","“变量赋值”动作【"+flagStr+"】下未选择具体属性，该动作只能针对具体变量下的属性进行赋值，不能对变量本身进行赋值!","info");
		return;
	}
	if(elseJson!=""){
		elseJson='{"var-assign":['+elseJson+']}'
	}
	if(thenJson=="")thenJson='""';
	if(elseJson=="")elseJson='""';
 	//alert(elseJson)
 	var tmprluename = $("#rulename").val();
 	if (tmprluename=="") tmprluename="rule"
	savejson='{"rule":{"remark":"'+$("#remark").val()+'",'
	savejson=savejson+'"if":'+ifJson+','
	savejson=savejson+'"then":'+thenJson+',' //then没有时为空
	savejson=savejson+'"else":'+elseJson+','
	savejson=savejson+'"_name":"'+tmprluename+'"'
 	savejson=savejson+'}}';
	//alert(savejson)
	console.log(savejson)
	
	var dicArr=[];
	$('#selectKeyWords li a', window.parent.document).each(function(index,itm){
		dicArr.push($(itm).attr("id"));
	})
	/* if(dicArr.length==0){
		$.messager.alert("提示","请选择目录！","info"); 
		return;
	} */
	var jsonnull = '{"rule":{"remark":"","if":{"and":{}},"then":"","else":"","_name":"rule"}}' //为空则不能保存
	if (savejson == jsonnull){
		$.messager.alert("提示","请维护内容后保存！","info"); 
		return;
	}
	var title = (status=="CancelRelease")?"取消发布":((status=="Release")?"发布":"保存")
	$.post(
 		"web.DHCCKBRuleSave.cls",
   		{json:savejson,
		 dicStr:dicArr.join("^"),
		 ruleId:$("#line").attr("data_id"),
		 LgUserId:LgUserID,
		 status:status,
		 loginInfo:LoginInfo	
		 },function(data){
	     	if(data.code>0){
	         	$.messager.alert("提示",title+"成功！","info",function(){
		         	window.parent.reloadTree();
		         	window.parent.getRuleIframe(data.code);
		        });          	
	         	
		    }else{

			    console.log(data)
		        //window._setDirty()
		        $.messager.alert("提示","保存失败！"+data.msg,"error"); 
			}
	},"json");
	
	/*runClassMethod("web.DHCCKBRuleSave","save",
		{"json": savejson,
		 "ruleId":$("#line").attr("data_id"),"dicStr":dicArr.join("^"), //目录和药品ID
		 "LgUserId":LgUserID,"status":"", 
		 "loginInfo":LoginInfo}, function(data){
	 	 	alert(data)
	 	  	//window.location.reload();
	   		/*if(data==0){
		   		$.messager.popover({msg: 'TISHI',type:'success',timeout: 1000});
		 	}*
 	})*/
}

///请选择数据集input回车事件 2020-12-02
function enterFind(){
	var enterType=$(attrsels).parent().parent().parent().attr("data_type");
	if(enterType=="Constant"){
	var dataId = $(attrsels).parent().prev().prev().prev().attr("data_id");
	var html = serverCall("web.DHCCKBRuleEditor","QueryDataHtmlByAttr",{"attrId":dataId,"q":$("#dataset").find("input").val()});
	$("#dataset").html("");
	$("#dataset").append(html);
	}
	var enterOnclick=$(attrsels).attr("onclick");
	if(enterOnclick=="chooseUnit(this)"){
		var dicTionId = serverCall("web.DHCCKBCommon","GetUnitData");
		var html = serverCall("web.DHCCKBRuleEditor","QueryDictonHtml",{"dicTionId":dicTionId,"q":$("#unit").find("input").val()});
		$("#unit").html("");
		$("#unit").append(html);	
	}
}

///逻辑框操作按钮点击事件 2021-03-24
function chooseCombox(choose){
	var pathYEd=(function(){ //2020-11-11 st 找应该的yEd
	  'use strict'
	  return  function fun(pathData,yRtn){
		 pathData=$("#line").find("path[data^='"+pathData+"']:last").attr("data");
			if(pathData!=undefined){
				yRtn=parseInt(pathData.split("P")[2]);
				var pathDataX=parseInt(pathData.split("P")[0]);
				var pathDataYEd=parseInt(pathData.split("P")[2]);
				var pathData=(pathDataX+1)+"P"+pathDataYEd+"P";
				var yRtn=fun(pathData,yRtn);
			}
	     return yRtn;
	  }   
	})()
	var getRealYEd=pathYEd; //ed
	
	id=_comboxLogicID;
	var x1=parseInt(id.split("Box")[0]);
	var y1=parseInt(id.split("Box")[1]);
	ComboxOpHide();//逻辑操作面板隐藏
	
	if(choose=="additem") //添加条件
	{
		pathData=id.replace("Box","P")+"P"; 
		var numPath=$("#line").find("path[data^='"+pathData+"']").size(); 
		if(numPath==0){
			var y2=y1;
		}else{
			yRtn=getRealYEd(pathData);
			resetHtmlAdd(x1,yRtn);
			var y2=yRtn+1;
		}//ed	
		displayPathAppend(x1,y1,y2); //画path
		displayPathConAppend(x1,y1,y2); //画con		
	}
	if(choose=="addunionitem"){ //添加联合条件
		var x2=parseInt(x1)+1;
		pathData=id.replace("Box","P")+"P"; 
		var numPath=$("#line").find("path[data^='"+pathData+"']").size(); 
		if(numPath==0){
			y2=y1;
		}else{
			yRtn=getRealYEd(pathData);
			resetHtmlAdd(x1,yRtn);
			y2=yRtn+1;
		}//ed	
		displayPathAppend(x1,y1,y2); //画path
		displayPathLogicAppend(x2,y2); //画logic
	}
    if(choose=="del"){
	  if(id=="1Box1"){return} 
	  if($("#PathCon").find("[data^="+x1+"P"+y1+"]").size()){
		  $.messager.alert("提示:","请先删除当前连接下子元素！","info");
		  return;
	  }
	  var bOXId=(parseInt(x1)+1)+"Box"+y1; //逻辑框1-逻辑框2时，逻辑框1不能被删除；
	  var number=$("#PathLog").find("#"+bOXId).size();
	  if(number>0){
		  $.messager.alert("提示:","请先删除当前连接下子元素！","info");
		  return;
	  } //ed
	  deleteLogic(x1,y1,id);
	  //resetHtml(x1,y1); //判断满足number小于1再调用
	  var bOXId=(parseInt(x1)-1)+"Box"+y1; //逻辑同行时（逻辑框1-逻辑框2）,删除逻辑2不需resetHtml和减小高度
	  var number=$("#PathLog").find("#"+bOXId).size();
	  var bOXId=bOXId.replace("Box","P")+"P";
	  var numberPath=$("#line").find("path[data^='"+bOXId+"']").size(); //有同父的同级的path时，即使满足number=1，也要reset
	  if((number<1)||(numberPath>0)){ //if(number<1){
		  resetHtml(x1,y1);
		  height=$("#line>div:first").height()-45; //st 删除逻辑的同时,调整高度 //原：30 2023-03-14样式修改
		  if(height==45)height=55; //原：if(height==30)height=40; 2023-03-14样式修改
			$("#line>div:first").height(height); //ed
	  } //ed	  
	  $(".combo-p").css("display","none");
	  return;
	}
}

//逻辑操作初始化 2021-03-25
function ComboxOpInit(){	
	$("input.combo-text.validatebox-text").mouseover(function(){		
		_comboxLogicID=$(this).parent().parent().find(".hisui-combobox").attr("id");
		$("#combox").css("display","block");
		$("#combox").css("left",$(this).offset().left);
		$("#combox").css("top",$(this).offset().top+$(this).height());
	});
	$("#combox").mouseleave(function(){
		$("#combox").css("display","none");
	});		
}

//逻辑操作面板隐藏 2021-03-25
function ComboxOpHide(){
	$("#combox").css("display","none");
	_comboxLogicID="";
}

//清空目录
function empty(){
	window.parent.clearKeyWord();
}
//发布
function release(){
	saveRule("Release")
}
//取消发布
function cancelRelease(){
	saveRule("CancelRelease")
}
//生命周期
function lifeCycle(){
	window.parent.lifeCycle(ruleId);
}

/// 分支扩展级别点击事件
function chooseManLevCombox(option){
	//var text = option.children[0].text;
	//var text = $(option).text();
	var levelId = serverCall("web.DHCCKBRuleEditor","GetLevelId",{}); //hxy 2022-05-17
	var defaultLevel = serverCall("web.DHCCKBRuleEditor","GetDefaultLevel",{"drugstr":_dicStr})	// qnp 2022-09-21 选择溶液时，增加默认级别
	defaultLevel = defaultLevel.split("^");
	$(option).next().remove();	
	var htmlOne="" 
	htmlOne=htmlOne+'<span>';
	htmlOne=htmlOne+'(';
	htmlOne=htmlOne+'<span class="lineext-darkcyan" onclick="chooseLevelVar(this)" data_id="'+levelId+'" par_data>管理级别</span>'; //2022-05-17 hxy 默认管理级别 st
	//htmlOne=htmlOne+'<span class="lineext-darkcyan" onclick="chooseLevelVar(this)">请选择变量</span>'; //2022-04-20 qnp 放消息级别 //ed
	htmlOne=htmlOne+'<span style="color: #EE0F0F;">=</span>' //red
	

	if ($(option).prevAll().last().text().indexOf("溶液")!=-1){
		htmlOne=htmlOne+'<span><span onmouseover="chooseDatasetlevel(this)" data_id="'+defaultLevel[0]+'" class="lineext-blue">'+ defaultLevel[1] +'</span></span>'	
	}else{
		htmlOne=htmlOne+'<span><span onmouseover="chooseDatasetlevel(this)" data_id="1" class="lineext-blue">请选择数据集</span></span>'
	}    
    htmlOne=htmlOne+')';
    htmlOne=htmlOne+'</span>';
    $(option).after(htmlOne);    
	return;
	
}
// 分支扩展级别选项面板
function chooseLevelVar(attr){
	
	AllUlPanel();
	$("#manlevelattr").css("display","block");
	$("#manlevelattr").css("left",$(attr).offset().left);
	$("#manlevelattr").css("top",$(attr).offset().top+$(attr).height());
	attrsels = attr;
}

///分支扩展级别-数据集事件
function chooseDatasetlevel(dataset)
{
	attrsels = dataset
	AllUlPanel();
	var dataId = $(dataset).parent().prev().prev().attr("data_id");	
	var html = serverCall("web.DHCCKBRuleEditor","QueryDataHtmlByAttr",{"attrId":dataId});
	$("#dataset").html("");
	$("#dataset").append(html);
	$("#dataset").css("display","block");
	$("#dataset").css("left",$(dataset).offset().left);
	$("#dataset").css("top",$(dataset).offset().top+$(dataset).height());
}

///分支扩展级别属性面板的点击事件
function selExtItems(selObj)
{	
	var selExtItemsId = $(selObj).attr('data');
	if (selExtItemsId == -100){	// -100标识删除
		$(attrsels).parent().remove();
		AllUlPanel();
		return;
	}	
	$(attrsels).attr('data_id',$(selObj).attr('data'));
	$(attrsels).attr('par_data',$(selObj).attr('par_data'));			//sufan 新增

	var name=$(selObj).attr('name');
	if(name==undefined){
		$(attrsels).html($(selObj).html())
		$(attrsels).parent().parent().attr('data_cate',$(selObj).attr('data')) //hxy 20201201  新增
	}
	AllUlPanel();
}

///请选择变量input回车事件 2022-05-24
function enterVarFind(obj){
	var parId=$(obj).attr("dataPar");
	var modelDesc=$(obj).attr("dataDesc");
	var data=$(obj).attr("data");
	var modelDicId=data.replace("sub","");
	var q=$('input[data="'+data+'"]').val();
	var data="#"+data;
	var html = serverCall("web.DHCCKBRuleEditor","QueryNextHtmlq",{"parId":parId,"modelDesc":modelDesc,"modelDicId":modelDicId,"q":q});
	$(data).html("");
	$(data).append(html);
}

///悬浮提示
function BindATips()
{
	var html='<div id="tip" style="border-radius:5px;display:none;border:1px solid #000;padding: 5px 8px;position:absolute;background-color:rgba(0,0,0,.7);color:#fff;"></div>'
	$('body').append(html);
		/// 鼠标离开
		$('.li-a').on({
			'mouseleave':function(){
				$("#tip").css({display : 'none'});
			}
		})
		/// 鼠标移动
		$('.li-a').on({
			'mousemove':function(){
				var tleft=(event.clientX + 20);
				//var title=$(this).text();
				/// tip 提示框位置和内容设定
				$("#tip").css({
					display : 'block',
					top : (event.clientY + 10) + 'px',   
					left : tleft + 'px',
					'z-index' : 9999,
					opacity: 1
				}).text(this.innerText);
			}
	})

}
/// Auth: qunianpeng
/// Desc: 作废规则
/// Date: 2022-11-30
function stopRule(){
	
	var ruleId = $("#line").attr("data_id");
	var status = "Stop";
	var loginInfo = LoginInfo;
	$.messager.confirm("提示", "您确定要作废规则吗？", function (res) {	// 提示是否复制
		if (res) {
			runClassMethod("web.DHCCKBRuleSave","StopRule",{"ruleId":ruleId,"status":status,"loginInfo":LoginInfo}, function(data){	 	 
		   		if(data>=0){
			   		window.parent.reloadTree();
			   		$.messager.popover({msg: '作废成功',type:'success',timeout: 1000});
			 	}else{
				 	$.messager.popover({msg: '作废失败',type:'error',timeout: 1000});
				 }
		 	})
		}
	});	
}

/// JQuery 初始化页面
$(function(){
	///  ruleId 不为空时再加载
	if(ruleId!=""){
		initPageDefault(); 
	}
})
