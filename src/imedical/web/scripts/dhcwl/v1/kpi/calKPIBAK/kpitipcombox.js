var opl=ipdoc.lib.ns("ipdoc.pattreatinfo");
opl.view=(function(){
	//alert("test3");
	InitPannelEvent();
	//初始化页面浮动
	function InitPannelEvent(){
		alert("test2");
		$("kpiInputIcon,kpiInforIcon").each(function(){
			alert("test1");
			var that=$(this);
			var ID=that.attr('id');
			that.parent().on({
				mouseenter:function(){
					if (LoadPopover("Load",that.attr('id'))){
						//浮动内容
						var HTML=GetPannelHTML(that.attr('id'));
						if (HTML.innerHTML==""){return;}
						that.webuiPopover({
							title:HTML.Title,
							content:HTML.innerHTML,
							trigger:'hover',
							placement:'bottom-left',
							onShow:function(){
								if (LoadPopover("Show",that.attr('id'))){
									if (typeof HTML.CallFunction == "function"){
										HTML.CallFunction.call();
									}
								}
							}
						});
						that.webuiPopover('show');
					}
				}
			});
		});
	}
	var LoadPopover=(function(){
		///防止多次初始化数据
		var AlreadLoadObj={};	//初始化元素
		var AlreadShowObj={};	//初始化显示数据
		return function(Type,ID){
			if (Type=="Load"){
				if (typeof AlreadLoadObj[ID] =="undefined"){
					AlreadLoadObj[ID] ="1";
					return true;
				}else{
					return false;
				}
			}else if (Type=="Show"){
				if (typeof AlreadShowObj[ID] =="undefined"){
					AlreadShowObj[ID] ="1";
					return true;
				}else{
					return false;
				}
			}
			
		}
	})();
	
	function showPannelWin(){
		var PannelObj=$(this).next();
		var Currid=$(this).attr("id");
		if (PannelObj.length==0){
			var Height="";
			var Width="";
			var title="";
			if ((Currid=="kpiInputIcon")||(Currid=="kpiInforIcon")){
				Height="200px",Width="100px";
				title="请设置标题";
			}else if ((Currid=="BloodPressure")||(Currid=="Temperature")||(Currid=="Pulse")){
				Height="400px",Width="600px";
				title="请设置标题";
			}else if ((Currid=="Lab")||(Currid=="Exam")){
				Height="300px",Width="700px";
				if (Currid=="Lab"){
					if ($("#LabCount").text()==0){return false;}
				}else if (Currid=="Exam"){
					if ($("#ExamCount").text()==0){return false;}
				}
			}else if (Currid=="CVReport"){
				if ($("#CVReport").text()==0){
					return false;
				}
				Height="300px",Width="700px";
			}else{
				Height="300px",Width="500px";
				title="请设置标题";
			}
			var HTML=GetPannelHTML(Currid);
			//$("#ShowPanel").panel("setTitle",title);
			var PannelClone=$("#ShowPanel").clone();
			PannelClone.attr('id',$(this).attr('id')+'Pannel')
			.css('height',Height)
			.css('width',Width)
			.append(HTML.innerHTML);
			$(this).parent().append(PannelClone);
			
			if (typeof HTML.CallFunction == "function"){
				HTML.CallFunction.call();
			}
			
			var PannelObj=$(this).next();
		}
		
		PannelObj.show();
		return;
	}
	function hidePannelWin(){
		var PannelObj=$(this).next();
		PannelObj.hide();
	}

	///获取动态写入的HTML代码
	function GetPannelHTML(LinkID){
		var innerHTML="";
		var CallFunction={};
		var Title="";
		if ((LinkID=="kpiInputIcon")||(LinkID=="kpiInforIcon")){
			if (LinkID=="kpiInforIcon"){
				Title="指标信息查看";
			}else if (LinkID=="kpiInputIcon"){
				Title="指标导入";
			}
			innerHTML+='<ul style="list-style-type:none">';
			var CurrArcimDR="",OrdItem="";
			var Desc=JsonData[i].Desc;
			var Value=JsonData[i].Value;
			var Checked=JsonData[i].Checked;
			//<input value="ALL" class='hisui-radio' type="radio" data-options="label:'全部',name:'PriorType_Radio',check:true">
			innerHTML+='<li>';
			innerHTML+="<a class='hisui-linkbutton big' data-options="+""+"iconImg:'../scripts_lib/hisui-0.1.0/dist/css/icons/big/book_arrow_rt.png',plain:true"+""+">有维度版</a>"
			innerHTML+="<a class='hisui-linkbutton big' data-options="+""+"iconImg:'../scripts_lib/hisui-0.1.0/dist/css/icons/big/book_arrow_rt.png',plain:true"+""+">有维度版</a>"
			innerHTML+='</li>'
			innerHTML+='</ul>'; 
			CallFunction=function(){
				
			};
		}
		return {
			"innerHTML":innerHTML,
			"CallFunction":CallFunction,
			"Title":Title
		}
	}
})();
﻿﻿