;$(function(){
	var lstItems ;
	var _body = '<div style="margin:10px 20px 10px 10px;float:left;">'
		+'<select id="alltabslist" multiple size="15" style="WIDTH:150px;HEIGHT:340px;overflow: auto;"></select>'
		+'</div>'
		+'<div style="margin:120px 10px;float:left;">'
		+'<a id="showOrHideBtn" href="#" style="display:block;margin:5px 0;" iconCls="icon-show-set" class="hisui-linkbutton">隐藏/显示</a>'
		+'<a id="upBtn" href="#" style="display:block;margin:5px 0;" iconCls="icon-arrow-top" class="hisui-linkbutton">上移</a>'
		+'<a id="downBtn" href="#" style="display:block;margin:5px 0;" iconCls="icon-arrow-bottom" class="hisui-linkbutton">下移</a>'
		+'</div>';
	var options = {};
	var rebuildJson = function(allJson,showJson){
		var newJsonArr = [];
		for (var i=0; i<showJson.length;i++){
			var id = showJson[i]["id"];
			if (showJson[i]["id"].indexOf("dataframe")>-1){
				id = id.slice(id.indexOf('dataframe')+9); //.split("dataframe")[1];
			}
			newJsonArr.push({title:showJson[i]["title"], id:id, hidden:false});
		}
		for(var i=0;i<allJson.length;i++){
			var item = allJson[i];
			for(var j=0; j<newJsonArr.length; j++){
				if (item["ChartID"]==newJsonArr[j]['id']){
					break;
				}
			}
			if (j==newJsonArr.length){
				newJsonArr.push({title:item["ChartName"], id:item["ChartID"], hidden:true});
			}
		}
		console.log(newJsonArr);
		return newJsonArr;
	}
	var createSelectList = function(json){
		var html = "";
		for (var i=0; i<json.length;i++){
			var cls = json[i].hidden?"opthide":"optshow";
			 html += "<option value='"+json[i].id+"' class='"+cls+"'>"+json[i].title+"</option>";
		}
		return html;
	};
	var swap = function(a,b){
		var opta=lstItems[a];
		var optb=lstItems[b];
		lstItems[a]= new Option(optb.text,optb.value);
		lstItems[a].className=optb.className;
		lstItems[b]= new Option(opta.text,opta.value);
		lstItems[b].className=opta.className;
		lstItems.selectedIndex=b;
	}
	var closeHandler = function(){
		$("#tabscfgwin").dialog("close");
	}
	var saveHandler = function(){
		var str = "";
		$("#alltabslist").find("option.optshow").each(function(){
			str +="|1^"+this.value;
		});
		$("#alltabslist").find("option.opthide").each(function(){
			str +="|0^"+this.value;
		});
		if (str.indexOf("|")>-1){
			$cm({
				ClassName:"websys.Preferences",
				MethodName:"SetData",
				objectType:"User.SSUser",
				objectReference:options.userId,
				appKey:"CHARTBOOK",
				appSubKey:options.tabsId,
				Data:str+"|",
				add:1
			},function(rtn){
				if (rtn==1){
					$.messager.popover({msg:'保存成功,下次进入当前界面生效。',type:"success"});
					closeHandler();
				}else{
					$.messager.popover({msg:'保存错误。'+rtn,type:"error"});
				}
			});
		}else{
			$.messager.popover({msg:'必须显示一个页签',type:"error"});
		}
	};
	var initEvent = function(){
		$("#upBtn").click(function(){
			var i=lstItems.selectedIndex;
			var len=lstItems.length;
			if(i>0 && len>1) swap(i,i-1);
		});
		$("#downBtn").click(function(){
			var i=lstItems.selectedIndex;
			var len=lstItems.length;
			if(i<(len-1) && len>1) swap(i,i+1);
		});
		$("#showOrHideBtn").click(function(){
			var s = $("#alltabslist").find("option:selected");
			if (s.length>0){
				var isShow = s.hasClass('optshow');
				s.each(function(ind,item){
					var _t = $(this);
					if(isShow && _t.hasClass('optshow')){
						_t.removeClass('optshow').addClass('opthide');
					}
					if(!isShow && _t.hasClass('opthide')){
						_t.removeClass('opthide').addClass('optshow');
					}
				});
				lstItems.selectedIndex=-1;
			}else{
				$.messager.popover({msg:'请选择左侧某元素',type:"alert"});
			}
		});
	}
	
	var init = function(opt){
		if (opt.tabsId){
			$cm({
				ClassName:"epr.ChartBook",QueryName:"LookUpItems",ID:opt.tabsId,List:""
			},function(allJson){
				var newJsonArr = rebuildJson(allJson.rows,opt.tabsShowJson);
				$("body").append("<div id='tabscfgwin'></div>");
				$("#tabscfgwin").dialog({
					title:"图表组自定义",
					iconCls:"icon-cfg",
					modal:true,width:600,height:450,
					content:_body,
					buttons:[{
						iconCls:'icon-w-save',
						text:'保存',
						handler:saveHandler
					},{
						iconCls:'icon-w-close',
						text:'取消',
						handler:closeHandler
					}]
				});
				$("#alltabslist").innerHTML ="";
				var html = createSelectList(newJsonArr);
				$("#alltabslist").append(html);
				lstItems = document.getElementById("alltabslist");
				initEvent();
			});
			return true;
		}else{
			return false;
		}			
	}
	$.tabscfg = function(opt){
		if (opt){
			options = opt
			init(opt);
		}
	}	
});