//$.req与$.cm相同,可直接调用后台流、对象等返回格式类方法与Query
(function($){
    $.extend({
        req:function(data,success,error){    //request server
            var result;
            var async=success==false?false:true;
            var url=data.url||"DHCDoc.Util.Broker.cls";
            if(typeof websys_getMWToken=='function') data.MWToken=websys_getMWToken();
            var ajaxRtn=$.ajax({
                url:url,
                async:async,
                type:'post',
                data:data,
                dataType:data.dataType||'json',
                success:function(rtn){
                    if(!async){
                        result=rtn;
                    }
                    if(typeof success=='function'){
                        success.call(this,rtn);
                    }
                },
                error:function(rtn,textStatus){
                    if(typeof error=='function'){
                        error.apply(this,arguments);
                    }
                    if(!$('#_HUI_Err_Dialog').size()){
                        $("body").append("<div id='_HUI_Err_Dialog' class='hisui-dialog' style='overflow:hidden;'></div>");
                    }
                    $('#_HUI_Err_Dialog').dialog({
                        iconCls:'icon-alert-red',
                        title:"Request Data Error:"+textStatus,    
                        width: 800,    
                        height: 600,    
                        closed: false,    
                        content:'<frame iframe width="100%" height="100%" frameborder="0">'+rtn.responseText+'</frame>',
                        modal: true
                    });
                }
            });
            if(!async) return result;
            return ajaxRtn;
        }
    });
})(jQuery);
//tooltip扩展为overflowtip 超过文本宽度自动提示
(function($){
    $.fn.overflowtip = function(){
        this.css({'overflow': 'hidden','text-overflow':'ellipsis'});
        return this.tooltip({
			content:'',
			onShow:function(){
                if(this.clientWidth<this.scrollWidth){
                    var content=$(this).getText();
					$(this).tooltip('tip').show();
					$(this).tooltip('update',content).tooltip('reposition');
                }else{
                    $(this).tooltip('tip').hide();
                }
			}
		});
    };
})(jQuery);
//numberbox默认与扩展
(function($){
    $.extend($.fn.numberbox.defaults, {
        precision:6,
        formatter:function(value){
            if((value!="")&&!isNaN(value)){
                value=parseFloat(value);
                $(this).numberbox('options').value=value;
            }
            return value;
        }
    });
})(jQuery);
//checkbox默认与扩展
(function($){
    $.extend($.fn.checkbox.defaults, {
        on:'Y',
        off:'N'
    });
})(jQuery);
//linkbutton默认与扩展
(function($){
    $.extend($.fn.linkbutton.defaults, {
        stopAllEventOnDisabled:true
    });
    $.extend($.fn.linkbutton.methods, {
        addTip:function(jq,content){    
            if(typeof content=='undefined') content='';
            var html='<div class="l-btn-tip" style="display:flex; align-items:center;justify-content:center;text-align:justify;';
                html+='position:absolute;right:-5px;top:-3px;min-width:16px;line-height:16px;font-size:smaller;border-radius:50%;';
                html+='color:#FFF; background-color:#F00;">'+content+'</div>';
            return jq.each(function(){
                $(this).css({'position':'relative'}).linkbutton('deleteTip').append(html);
            });   
        },
        deleteTip:function(jq){
            return jq.each(function(){    
                $(this).find('.l-btn-tip').remove();
            });   
        }
    });
})(jQuery);
//menu默认与扩展
(function($){
    $.extend($.fn.menu.methods, {    
		showItem:function(jq, itemEl){    
			return jq.each(function(){
				if($.isArray(itemEl)){
					for(var i=0;i<itemEl.length;i++)
						$(itemEl[i]).show().next('.menu-sep').show();  
				}else{
					$(itemEl).show().next('.menu-sep').show();  
				}  
				$(this).menu('resize');
			});    
		},
		hideItem:function(jq, itemEl){    
			return jq.each(function(){
				if($.isArray(itemEl)){
					for(var i=0;i<itemEl.length;i++)
						$(itemEl[i]).hide().next('.menu-sep').hide();  
				}else{
					$(itemEl).hide().next('.menu-sep').hide();  
				}
				$(this).menu('resize');    
			});    
		},
		resize:function(jq){    
			return jq.each(function(){  
				var height=0;
				$(this).children('.menu-item').each(function(){
					if($(this).css('display')!='none'){
						height+=$(this).outerHeight()+7;
					}
				});
				$(this).height(height).next('.menu-shadow').height(height+14);  
			});    
		},
		removeSubMenu:function(jq,target){
			return jq.each(function(){  
				if(target.submenu){
					if(target.submenu[0].shadow){
						target.submenu[0].shadow.remove();
					}
					target.submenu.remove();
					delete target.submenu;
				}
			});
		},
		getSubMenu:function(jq,target){
			return target.submenu;
		}
	}); 
})(jQuery);
//tabs默认与扩展
(function($){
    $.extend($.fn.tabs.methods, {
        clearTabs: function(jq){    
            return jq.each(function(){ 
				var opts=$(this).tabs('options');
				var onSelect=opts.onSelect;
				var onBeforeClose=opts.onBeforeClose;
                var onBeforeSelect=opts.onBeforeSelect;
				opts.onSelect=function(){};
                opts.onBeforeSelect=function(){};
				opts.onBeforeClose=function(){};
				var length=$(this).tabs('tabs').length;
				for(var i=length;i>0;i--){
					$(this).tabs('close',i-1);
				}
				opts.onSelect=onSelect;
				opts.onBeforeClose=onBeforeClose;
                opts.onBeforeSelect=onBeforeSelect;
			}); 
        }    
    });
})(jQuery);
//keywords默认与扩展
(function($){
    $.extend($.fn.keywords.methods, { 
		append:function(jq,item){
			return jq.each(function(){
				var opts = $.data(this, 'keywords').options;
				opts.items.push(item);
                if($(this).children('ul.keywords').size()){				
                    $(this).children('ul.keywords').append('<li id="'+(item.id||item.text)+'" rowid="'+(opts.items.length-1)+'"><a>'+item.text+'</a></li>');
                    if(item.selected) $(this).keywords('select',item.id);
                }else{
                    $(this).keywords(opts);
                }
			});
		},
        remove:function(jq,id){
            return jq.each(function(){
                var items = $.data(this, 'keywords').options.items;
                for(var i=items.length-1;i>=0;i--){
                    if(items[i].id==id){
                        items.splice(i,1);
                    }
                }
                $(this).children('ul.keywords').children('li#'+id).remove();
            });
        },
		addCloseICON:function(jq,id){
			return jq.each(function(){
				var opts = $.data(this, 'keywords').options;
				var $li=(id==undefined)?$(this).children('ul.keywords').children('li'):$(this).children('ul.keywords').children('li#'+id);
				$li.each(function(){
					var that=this;
					var item=opts.items[$(that).index()];
					$('<div></div>').addClass('icon-close').appendTo($(that)).click(function(e){
						e.preventDefault();
						if(opts.onClose) opts.onClose.call(that,item);
						return false;
					});
				});
			});
		},
        addTip:function(jq,param){
            var id=param.id;
            var content=param.content;
            if(typeof content=='undefined') content='';
            var html='<div class="l-btn-tip" style="display:flex; align-items:center;justify-content:center;text-align:justify;';
                html+='position:absolute;right:-5px;top:-3px;min-width:16px;line-height:16px;font-size:smaller;border-radius:50%;';
                html+='color:#FFF; background-color:#F00;">'+content+'</div>';
            return jq.each(function(){
                $(this).keywords('deleteTip',id).children('ul.keywords').children('li#'+id).css({'position':'relative'}).append(html);
            });   
        },
        deleteTip:function(jq,id){
            return jq.each(function(){    
                $(this).children('ul.keywords').children('li#'+id).find('.l-btn-tip').remove();
            });   
        }
	});
})(jQuery);
//combobox默认与扩展
(function($){
    var url='DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Combo';
    if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
    $.extend($.fn.combobox.defaults, {  
        valueField:'id',
        textField:'text', 
        panelHeight:200, 
        mode:"local",
        url:url,
        filter: function(q, row){
            var opts = $(this).combobox('options');
            return row[opts.textField].toUpperCase().indexOf(q.toUpperCase()) >= 0;
        },
        onLoadError:function(){
            debugger;
            $.messager.alert('提示','初始化下拉框失败!','error');
        }
    });
    $.extend($.fn.combobox.methods, {
        select:function(jq,value){
            return jq.each(function(){
                $(this).combobox('setValue',value);
                var opts=$(this).combobox('options');
                var valueField=opts.valueField;
                var data=$(this).combobox('getData');
                for(var i=0;i<data.length;i++){
                    if(data[i][valueField]==value){
                        opts.onSelect.call(this,data[i]);
                        break;
                    }
                }
            });
        }
    });
})(jQuery);
//基于combobox扩展singleCombo插件支持ClassName、QueryName、queryParams属性
(function($){
    $.fn.singleCombo = function(opts){
        if(typeof opts =='object'){
            var ChangeTimer;
            $.extend(opts,{
                onChange:function(){
                    clearTimeout(ChangeTimer);
                    var target=this;
                    ChangeTimer=setTimeout(function(){
                        if($(target).combobox('panel').find(":visible").size()==1){
                            var index=$(target).combobox('panel').find(":visible").index();
                            var Data=$(target).combobox('getData');
                            var valueField=$(target).combobox('opts').valueField;
                            $(target).combobox('select',Data[index][valueField]);
                            $(target).combobox('hidePanel');
                        }
                    },300);
                }
            },opts);
            opts.url=opts.url||$.fn.combobox.defaults.url;
            opts.url+=(opts.url.indexOf("?")>-1?'&':'?')+'ClassName='+opts.ClassName+"&QueryName="+opts.QueryName;
            if(opts.queryParams){
                $.each(opts.queryParams,function(key,value){
                    opts.url+="&"+key+'='+value;
                });
            }
            if(typeof websys_writeMWToken=='function') opts.url=websys_writeMWToken(opts.url);
        }
        arguments[0]=opts;
        return $(this).combobox.apply(this,arguments);
    }
})(jQuery);
//combogrid默认与扩展
(function($){
    var url='DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Grid';
    if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
    $.extend($.fn.combogrid.defaults, {
        idField:"id",
        textField:"text",
        mode:'remote',
        url:url,
        onLoadError:function(){
            debugger;
            $.messager.alert('提示','表格初始化失败!','error');
        }
    });
})(jQuery);
//datagrid默认与扩展
(function($){
    var url='DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Grid';
    if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
    $.extend($.fn.datagrid.defaults, {    
        striped:true,
        fit:true,
        fitColumns:true,
        singleSelect:true,
        rownumbers:true,
        pagination:false,
        url:url,
        onLoadError:function(){
            $.messager.alert('提示','表格初始化失败!','error');
        }
    });
    $.extend($.fn.datagrid.defaults.editors, {
        select:{
            init: function(container, options){   
                var input = $('<select class="datagrid-editable-input" ></select>').appendTo(container);
                input.maryselect(options);
                return input;   
            },   
            getValue:function(target){   
                return $(target).getValue();   
            },   
            setValue:function(target, value){
                // if(typeof(value)!='undefined'){
                //     $(target).setValue(value);   
                // }
            },   
            resize:function(target, width){
                $(target)._outerWidth(width)._outerHeight(30); 
            }
        },
        datetimeboxq: {
            init: function(e, t) {
                var i = $('<input type="text">').appendTo(e);
                i.datetimeboxq(t);
                return i;
            },
            destroy: function(e) {
                $(e).datetimeboxq("destroy");
            },
            getValue: function(e) {
                return $(e).datetimeboxq("getValue");
            },
            setValue: function(e, t) {
                $(e).datetimeboxq("setValue", t);
            },
            resize: function(e, t) {
                $(e).datetimeboxq("resize", t);
            }
        }
    });
    $.extend($.fn.datagrid.methods, {
        getEditRows:function(jq){
            var editRows=new Array();
            var opts=jq.datagrid('options');
            var idField= opts.idField;
            var rows=jq.datagrid('getRows');
            for(var i=0;i<rows.length;i++){
                var Editors=jq.datagrid('getEditors',i);
                if(!Editors.length) continue;
                var row=rows[i];
                $.each(Editors,function(){
                    var colOpts=jq.datagrid('getColumnOption',this.field);
                    if(colOpts.valueField){
                        row[colOpts.valueField]=$(this.target).getValue();
                        row[this.field]=$(this.target).getText();
                    }else{
                        row[this.field]=$(this.target).getValue();
                    }
                });
                if(idField&&!row[idField]) row[idField]="";
                editRows.push(row);
            }
            return editRows;
        },
        isEditing:function(jq){
            for(var i=0;i<jq.length;i++){
                var rows=$(jq[i]).datagrid('getRows');
                for(var j=0;j<rows.length;j++){
                    var Editors=$(jq[i]).datagrid('getEditors',j);
                    if(Editors.length){
                        return true;
                    }
                }
            }
            return false;    
        },
        addTip:function(jq,btn,size){
            if(!size) size=9;
            if(btn==undefined) btn='保存';
            var html="<i style='display:block;background:#f00;border-radius:50%;";
            html+="width:"+size+"px;height:"+size+"px;top:1px;right:1px;position:absolute;'></i>"
            return jq.each(function(){
                if(isNaN(btn)){
                    $(this).parent().parent().find('.datagrid-toolbar').find('.l-btn-text:contains('+btn+')').append(html);
                }else{
                    $(this).parent().parent().find('.datagrid-toolbar').find('.l-btn-plain').eq(btn).find('.l-btn-text').append(html);
                }
            });   
        },
        deleteTip:function(jq,btn){
            if(btn==undefined) btn='保存';
            return jq.each(function(){
                if(isNaN(btn)){
                    $(this).parent().parent().find('.datagrid-toolbar').find('.l-btn-text:contains('+btn+')').find('i').remove();
                }else{
                    $(this).parent().parent().find('.datagrid-toolbar').find('.l-btn-plain').eq(btn).find('i').remove();
                }
            }); 
        },
        localFilter:function(jq,param){
            var desc=param.text.toUpperCase();
            return jq.each(function(){
                var maxIndex=-1;
                var rows=$(this).datagrid('getRows');
                var dc = $.data(this, "datagrid").dc;
                dc.body2.find('tr.datagrid-row').each(function(i){
                    var row=rows[i];
                    var ContainFlag=false;
                    $.each(param.columns,function(index,field){
                        if(row[field].toUpperCase().indexOf(desc)>-1){
                            ContainFlag=true;
                            return false;
                        }
                    });
                    if(ContainFlag) $(this).show(),maxIndex++;
                    else $(this).hide();
                });
                dc.body1.find('tr.datagrid-row').each(function(index){
                    if(index<=maxIndex) $(this).show();
                    else  $(this).hide();
                });
            });
        },
        moveSelRow:function(jq,arrow){
            var curRow=jq.datagrid('getSelected');
            if(!curRow){
                $.messager.popover({msg:'请选择需要移动的行!',type:'alert'});
                return false;
            }
            if(jq.datagrid('isEditing')){
                $.messager.popover({msg:'请先完成正在编辑的行!',type:'alert'});
                return false;
            }
            var index=jq.datagrid('getRowIndex',curRow);
            var rows=jq.datagrid('getRows');
            var changeIndex=-1;
            if(arrow=='UP'){
                if(index==0){
                    $.messager.popover({msg:'已是第一行!',type:'alert'});
                    return false;
                }
                changeIndex=index-1;
            }else{
                if(index==(rows.length-1)){
                    $.messager.popover({msg:'已是最后一行!',type:'alert'});
                    return false;
                }
                changeIndex=index+1;
            }
            rows[index]=rows[changeIndex];
            rows[changeIndex]=curRow;
            jq.datagrid('refreshRow',index).datagrid('refreshRow',changeIndex).datagrid('selectRow',changeIndex);
            return jq;
        },
        removeInvalidEditRow:function(jq,columns){
            return jq.each(function(){
                var rows= $(this).datagrid('getRows');
                for(var i=rows.length;i>=0;i--){
                    var Editors= $(this).datagrid('getEditors',i);
                    if(!Editors.length) continue;
                    var findValFlag=false;
                    for(var j=0;j<Editors.length;j++){
                        if(columns.indexOf(Editors[j].field)>-1){
                            var val=$(Editors[j].target).getValue();
                            if(val!=''){
                                findValFlag=true;
                                break;
                            }
                        }
                    }
                    if(!findValFlag){
                        $(this).datagrid('deleteRow',i);
                    }
                }
            });
        }
    });
})(jQuery);
//基于datagrid扩展singleGrid插件,支持对表简单增删改查 idField为实体类rowid字段
(function($){
    $.fn.singleGrid = function(opts){
        var $dg=this;
        if(typeof opts =='object'){
            var idField=opts.idField||'ID';
            var toolbar=opts.toolbar||[];
            if(opts.useBaseToolbar){
                var BaseToolbar=[{
                    text:'增加',
                    iconCls: 'icon-add',
                    handler: function(){
                        var row={};
                        if(typeof opts.getInitRow=='function'){
                            var defRow=opts.getInitRow.call($dg[0]);
                            if((defRow===false)||(defRow===undefined)) return;
                            row=defRow||{};
                        }
                        $dg.datagrid('appendRow',row);
                        var rows= $dg.datagrid('getRows');
                        $dg.datagrid('beginEdit',rows.length-1).datagrid('scrollTo',rows.length-1);
                    }
                },'-',{
                    text:'修改',
                    iconCls: 'icon-edit',
                    handler: function(){
                        var Selected= $dg.datagrid('getSelected');
                        if(!Selected){
                            $.messager.popover({msg:"请选择需要修改项目",type:'alert'});
                            return;
                        }
                        var index= $dg.datagrid('getRowIndex',Selected);
                        $dg.datagrid('beginEdit',index);
                    }
                },'-',{
                    text:'删除',
                    iconCls: 'icon-remove',
                    handler: function(){
                        var Selected= $dg.datagrid('getSelected');
                        if(!Selected){
                            $.messager.popover({msg:"请选择需要删除的数据",type:'alert'});
                            return;
                        }
                        if(Selected[idField]){
                            $.messager.confirm('提示','确定删除此条数据?',function(r){
                                if(r){
                                    var ret=$.cm({
                                        ClassName:'DHCDoc.DHCDocConfig.Common',
                                        MethodName:'DeleteData',
                                        ClsName:opts.clsName,
                                        ID:Selected[idField],
                                        dataType:'text',
                                        _headers:{'X-Accept-Tag':1}
                                    },false);
                                    if(ret=='0'){
                                        $.messager.popover({msg:"删除成功",type:'success'});
                                        $dg.datagrid('load');
                                    }else{
                                        $.messager.alert('提示','删除失败:'+ret);
                                    }
                                }
                            });
                        }else{
                            var index=$dg.datagrid('getRowIndex',Selected);
                            $dg.datagrid('deleteRow',index);
                        }
                    }
                },'-',{
                    text:'保存',
                    iconCls: 'icon-save',
                    handler: function(){
                        var SaveRows=$dg.datagrid('getEditRows');
                        SaveRows=opts.checkSaveRows.call($dg[0],SaveRows);
                        if((SaveRows===false)||(SaveRows===undefined)) return;
                        if(!SaveRows.length){
                            $.messager.popover({msg:"没有需要保存的数据",type:'alert'});
                            return;
                        }
                        var ret=$.cm({
                            ClassName:'DHCDoc.DHCDocConfig.Common',
                            MethodName:'SaveData',
                            ClsName:opts.clsName,
                            InputStr:JSON.stringify(SaveRows),
                            IDField:idField,
                            dataType:'text',
                            _headers:{'X-Accept-Tag':1}
                        },false);
                        if(ret=='0'){
                            $.messager.popover({ msg: '保存成功!',type:'success'});
                            $dg.datagrid('load');
                        }else{
                            $.messager.alert('提示','保存失败:'+ret);
                        }
                    }
                }];
                if(toolbar.length){
                    toolbar=BaseToolbar.concat(['-'],toolbar);
                }else{
                    toolbar=BaseToolbar;
                }
            }
            $.extend(opts,{
                toolbar:toolbar,
                onDblClickRow:function(index, row){
                    $dg.datagrid('beginEdit',index);
                }
            },opts);
        }
        arguments[0]=opts;
        return $dg.datagrid.apply($dg,arguments);
    }
})(jQuery);
//tree默认与扩展
(function($){
    var url='DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Tree';
    if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
    $.extend($.fn.tree.defaults, {    
        singleSelect:true,
        url:url,
        onLoadError:function(){
            debugger;
            $.messager.alert('提示','初始化树失败','error');
        }
    }); 
    $.extend($.fn.tree.methods, { 
		unselectAll:function(jq){
			return jq.each(function(){  
				$(this).find("div.tree-node-selected").removeClass('tree-node-selected');
			});
		}, 
		getLevel:function(jq, target){  
			var id=jq.tree('getNode',target).id;
			if(id) return id.split('_').length;
			return ReculParNode(target,0);
			function ReculParNode(target,level){
				var parNode=jq.tree('getParent',target);
				return parNode?ReculParNode($('#'+parNode.domId)[0],++level):++level;
			}
		},
		addEditNode:function(jq,parTarget){
			return jq.each(function(){  
				$(this).tree('append',{parent:parTarget,data:[{id:'',text:''}]});
				if(parTarget){
					var parNode=$(this).tree('getNode',parTarget)
					var node=parNode.children[parNode.children.length-1];
				}else{
					var roots=$(this).tree('getRoots');
					var node=roots[roots.length-1];
				}
				$(this).tree('beginEditNew',$('#'+node.domId)[0]);
				if(!$(this).tree('getEditor',$('#'+node.domId)[0]).size()){
					$(this).tree('remove',$('#'+node.domId)[0]);
				}
			});
		},
		beginEditNew:function(jq,target){
			return jq.each(function(){
				var node=$(this).tree('getNode',target);
				var opts=$(this).tree('options');
				if(opts.onBeforeEditNew){
					if(opts.onBeforeEditNew.call(this,node)==false){
						return true;
					}
				}
				$(this).tree('beginEdit',target).tree('scrollTo',target);
				var ed=$(this).tree('getEditor',target);
				ed.unbind('blur').unbind('keydown');	//移除HISUI自带事件
				ed.css({width:$(target).width()-ed.position().left-5});
				if(opts.onBeginEdit) opts.onBeginEdit.call(this,node);
			});
		},
		endEditNew:function(jq,target){
			return jq.each(function(){
				var opts=$(this).tree('options');
				if(opts.onEndEdit){
					var node=$(this).tree('getNode',target);
					if(opts.onEndEdit.call(this,node)==false){
						return true;
					}
				}
				$(this).tree('endEdit',target);
			});
		},
		getEditor:function(jq,target){
			return $(target).find('input.tree-editor');
		},
		getEditingNodes:function(jq){
			var nodes=new Array();
			jq.each(function(){
				var eds=$(this).find('input.tree-editor');
				for(var i=0;i<eds.size();i++){
					var target=eds.eq(i).closest('.tree-node')[0];
					var node=$(this).tree('getNode',target);
					if(!node) continue;
					nodes.push(node);
				}
			});
			return nodes;
		},
		getSelected:function(jq){
			var nodeArr=new Array();
			for(var i=0;i<jq.length;i++){
				var $tree=jq.eq(i);
				var $node=$tree.find("div.tree-node-selected:visible");
				for(var j=0;j<$node.length;j++){
					var node=$tree.tree('getNode',$node[j]);
					nodeArr.push(node);
				}
			}
			return nodeArr;
		},
		select:function(jq,target){
			return jq.each(function(){
				var opts = $(this).tree('options');
				var node=$(this).tree('getNode',target);
				if (opts.onBeforeSelect.call(this, node) == false) {
					return;
				}
				if(opts.singleSelect){
					$(this).find("div.tree-node-selected").removeClass("tree-node-selected");
				}
				$(target).addClass("tree-node-selected");
        		opts.onSelect.call(this, node);
			});
		},
		unselect:function(jq,target){
			return jq.each(function(){
				$(target).removeClass("tree-node-selected");
			});
		},
		selectAll:function(jq){
			return jq.each(function(){
				var target=this;
				var roots=$(target).tree('getRoots');
				RecurSelectTree(roots);
				function RecurSelectTree(data){
					for(var i=0;i<data.length;i++){
						$(target).tree('select',data[i].target);
						if(data.children) RecurSelectTree(data.children);
					}
				}
			});
		},
		isSelected:function(jq,target){
			return $(target).hasClass('tree-node-selected');
		},
        enableMulSelModel:function(jq){
            return jq.each(function(){
                var $tree=$(this);
                $tree.unbind('click').bind('click',function(e){
                    var tt = $(e.target);
                    var $node = tt.closest("div.tree-node");
                    if (!$node.length) {
                        return;
                    }
                    var node=$tree.tree('getNode',$node[0]);
                    if (tt.hasClass("tree-hit")) {
                        if(node.state=='open') $tree.tree('collapse',$node[0]);
                        else $tree.tree('expand',$node[0]);
                        return false;
                    } else {
                        if (tt.hasClass("tree-checkbox")) {
                            if(node.checked) $tree.tree('uncheck',$node[0]);
                            else $tree.tree('check',$node[0]);
                            return false;
                        } else {
                            var opts = $tree.tree('options');
                            if (!$node.hasClass('tree-node-selected')&&opts.onBeforeSelect.call($tree[0], node) == false) {
                                return false;
                            }
                            if(e.shiftKey){
                                var $brother=null;
                                if($node.parent().nextAll().children("div.tree-node-selected").length){
                                    $brother=$node.parent().nextUntil($node.parent().nextAll().children("div.tree-node-selected").parent()).children('div.tree-node');
                                }else if($node.parent().prevAll().children("div.tree-node-selected").length){
                                    $brother=$node.parent().prevUntil($node.parent().prevAll().children("div.tree-node-selected").parent()).children('div.tree-node');
                                }
                                if($brother){
                                    $brother.each(function(){
                                        $(this).addClass("tree-node-selected");
                                        var newNode=$tree.tree('getNode',this);
                                        opts.onSelect.call($tree[0], newNode);
                                    });
                                }
                                $node.addClass("tree-node-selected");
                            }else{
                                var singleSelect=opts.singleSelect?!e.ctrlKey:e.ctrlKey;
                                if(singleSelect) $tree.find("div.tree-node-selected").not($node).removeClass("tree-node-selected");
                                if($node.hasClass("tree-node-selected")){
                                    $node.removeClass("tree-node-selected");
                                }else{
                                    $node.addClass("tree-node-selected");
                                }
                            }
                            if($node.hasClass("tree-node-selected")){
                                opts.onSelect.call($tree[0], node);
                            }else{
                                if(opts.onUnselect) opts.onUnselect.call($tree[0], node);
                            }
                            opts.onClick.call($tree[0], node);
                        }
                    }
                    e.preventDefault();
                    e.stopPropagation();
                    return false;
                });
            });
        }
	});
})(jQuery);
//treegrid默认与扩展
(function($){
    var url='DHCDoc.Util.QueryToJSON.cls?JSONTYPE=Tree';
    if(typeof websys_writeMWToken=='function') url=websys_writeMWToken(url);
    $.extend($.fn.treegrid.defaults, {
        idField:"id",
        treeField:"text",
        striped:true,
        fit:true,
        fitColumns:true,
        singleSelect:true,
        pagination:false,
        url:url,
        onLoadError:function(){
            $.messager.alert('提示','初始化树表格失败','error');
        }
    });
    $.extend($.fn.treegrid.methods, {
        isEditing:function(jq,param){
            var id=param,includeChild=false;
            if(typeof(param)=='object'){
                id=param.id,includeChild=param.includeChild
            }
            var rows=new Array();
            if((typeof(id)=='undefined')||(id=='')||(id==null)){
                rows=jq.treegrid('getRoots');
            }else{
                var row=$.extend({},$('#tabList').treegrid('find',id));
                if(row) rows.push(row);
            }
            var idField=jq.treegrid('options').idField;
            return RecurRows(rows);
            function RecurRows(rows){
                var EditingFlag=false;
                if(!rows) return EditingFlag;
                $.each(rows,function(){
                    if(jq.treegrid('getEditors',this[idField]).length){
                        EditingFlag=true;
                        return false;
                    }
                    if(!EditingFlag&&includeChild) EditingFlag=RecurRows(this.children);
                });
                return EditingFlag;
            }
        },
        getMaxID:function(jq){
            var rows=jq.treegrid('getRoots');
            var idField=jq.treegrid('options').idField;
            return GetMaxID(rows,0);
            function GetMaxID(data,MaxID){
                $.each(data,function(){
                    if(Number(this[idField])>MaxID){
                        MaxID=Number(this[idField]);
                    }
                    if(this.children){
                        MaxID=GetMaxID(this.children,MaxID);
                    }
                });
                return MaxID;
            }
        },
        getRowData:function(jq,id){
            var idField=jq.treegrid('options').idField;
            var row=$.extend({},jq.treegrid('find',id));
            if(row.children){
                for(var i=0;i<row.children.length;i++){
                    row.children[i]=jq.treegrid('getRowData',row.children[i][idField]);
                }
            }
            var eds=jq.treegrid('getEditors',id);
            $.each(eds,function(){
                if(!this.field) return true;
                var colOpts=jq.treegrid('getColumnOption',this.field);
                if(colOpts.valueField){
                    row[colOpts.valueField]=$(this.target).getValue();
                    row[this.field]=$(this.target).getText();
                }else{
                    row[this.field]=$(this.target).getValue();
                }
            });
            return row;
        },
        setRowData:function(jq,param){
            return jq.each(function(){
                var id=param.id,newRow=param.row;
                if($(this).treegrid('isEditing',id)){
                    var target=this;
                    var row=$(this).treegrid('find',id);
                    var $tr=$(target).data('datagrid').dc.view.find('tr[node-id="'+id+'"]');
                    var columns=$(this).treegrid('options').columns[0];
                    $.each(columns,function(){
                        var field=this.field,valueField=this.valueField;
                        if((typeof(newRow[field])=='undefined')&&(typeof(newRow[valueField])=='undefined')){
                            return true;
                        }
                        var value=newRow[field];
                        var ed=$(target).treegrid('getEditor',{id:id,field:field});
                        if(ed){
                            var text=value;
                            if(typeof(newRow[valueField])!='undefined'){
                                value=newRow[valueField]
                            }
                            $(ed.target).setValue(value,text);
                        }else{
                            row[field]=value;
                            var $cell=$tr.find('td[field="'+field+'"]').find('div.datagrid-cell');
                            if($cell.find('.tree-title').size()){
                                $cell.find('.tree-title').html(value)
                            }else{
                                $cell.html(value);
                            }
                        }
                    });
                }else{
                    $(this).treegrid('update',param);
                }
            });
        },
        getDataRows:function(jq,parId){
            var newRows=new Array();
            if((typeof(parId)=='undefined')||(parId=='')||(parId==null)){
                var rows=jq.treegrid('getRoots');
            }else{
                var rows=jq.treegrid('getChildren',parId);
            }
            var idField=jq.treegrid('options').idField;
            $.each(rows,function(){
                newRows.push(jq.treegrid('getRowData',this[idField]));
            });
            return newRows;
        },
        getEditRows:function(jq,parId){
            var newRows=new Array();
            var idField=jq.treegrid('options').idField;
            if((typeof(parId)=='undefined')||(parId=='')||(parId==null)){
                var rows=jq.treegrid('getRoots');
            }else{
                var rows=jq.treegrid('getChildren',parId);
            }
            $.each(rows,function(){
                if(jq.treegrid('isEditing',{id:this[idField],includeChild:true})){
                    newRows.push(jq.treegrid('getRowData',this[idField]));
                }
            });
            return newRows;
        },
        getPrevRow:function(jq,id){
            var parId;
            if((typeof(id)!='undefined')&&(id!='')&&(id!=null)){
                var parRow=jq.treegrid('getParent',id);
                if(parRow) parId=parRow.id;
            }
            var idField=jq.treegrid('options').idField;
            var rows=jq.treegrid('getDataRows',parId);
            if(typeof(id)=='undefined'){
                return rows[rows.length-1]||null;
            }
            for(var i=0;i<rows.length;i++){
                if(rows[i][idField]==id)
                    return rows[i-1]||null;
            }
            return null;
        },
        localFilter:function(jq,param){
            var desc=param.text.toUpperCase();
            return jq.each(function(){
                var idField=$(this).treegrid('options').idField;
                var dc = $.data(this, "treegrid").dc;
                var data=$(this).treegrid('getData');
                RecurRows(data);
                function RecurRows(rows){
                    var ExistContain=false;
                    for(var i=0;i<rows.length;i++){
                        var row=rows[i];
                        var ContainFlag=false;
                        if(row.children){
                            ContainFlag=RecurRows(row.children);
                        }
                        if(!ContainFlag){
                            $.each(param.columns,function(index,field){
                                if(row[field].toUpperCase().indexOf(desc)>-1){
                                    ContainFlag=true;
                                    return false;
                                }
                            });
                        }
                        if(ContainFlag){
                            ExistContain=true;
                            dc.body2.find('tr.datagrid-row[node-id="'+row[idField]+'"]').show();
                        }else{
                            dc.body2.find('tr.datagrid-row[node-id="'+row[idField]+'"]').hide();
                        }
                    }
                    return ExistContain;
                }
            });
        }
    });
})(jQuery);
//hisui插件赋值、取值、禁用公共方法
(function($){
    //获取插件类型
    $.fn.getPlugin=function(){
        var plugin='';
        var className=this.attr('class')||'';
        var childClassName=this.children().attr('class')||'';
        var prevClassName=this.prev().attr('class')||'';
        var classArr=className.split(' ');
        var childClassArr=childClassName.split(' ');
        var prevClassArr=prevClassName.split(' ');
        if(classArr.indexOf('maryselect-f')>-1){
            plugin='maryselect';
        }else if(classArr.indexOf('combogrid-f')>-1){
            plugin='combogrid';
        }else if(classArr.indexOf('combobox-f')>-1){
            plugin='combobox';
        }else if(classArr.indexOf('lookup')>-1){
            plugin='lookup';
        }else if(classArr.indexOf('numberbox-f')>-1){
            plugin='numberbox';
        }else if(classArr.indexOf('datetimeboxq-f')>-1){
            plugin='datetimeboxq';
        }else if(classArr.indexOf('timespinner-f')>-1){
            plugin='timespinner';
        }else if(classArr.indexOf('timeboxq')>-1){
            plugin='timeboxq';
        }else if(classArr.indexOf('dateboxq')>-1){
            plugin='dateboxq';
        }else if(classArr.indexOf('datebox-f')>-1){
            plugin='datebox';
        }else if(classArr.indexOf('checkbox-f')>-1){
            plugin='checkbox';
        }else if(classArr.indexOf('radio-f')>-1){
            plugin='radio';
        }else if(classArr.indexOf('slider-f')>-1){
            plugin='slider';
        }else if(classArr.indexOf('datagrid-f')>-1){
            plugin='datagrid';
        }else if((classArr.indexOf('hisui-switchbox')>-1)||(classArr.indexOf('switch-mini')>-1)){
            plugin='switchbox';
        }else if(childClassArr.indexOf('kw-section-list')>-1){
            plugin='keywords';
        }else if(prevClassArr.indexOf('numberbox-f')>-1){
            plugin='numberbox';
        }
        return plugin;
    }
    $.fn.setValue = function(value,text){
        if(text==undefined) text=value;
        return this.each(function(){
            var plugin=$(this).getPlugin();
            if(plugin=='combobox'){
                var oldValue=$(this).combobox('getValue');
                if(oldValue!=value){
                    $(this).combobox('select',value);
                } 
            }else if(plugin=='lookup'){
                var oldValue=$(this).lookup('getValue');
                if(oldValue!=value){
                    if(value!=''){
                        var idField=$(this).lookup('options').idField;
                        var textField=$(this).lookup('options').textField;
                        var grid= $(this).lookup('grid');
                        if(grid){
                            try{
                                var rows = grid.datagrid('getRows');
                                var find=false;
                                for(var i=0;i<rows.length;i++){
                                    if(rows[i][idField]==value){
                                        find=true;
                                        $(this).lookup('setText',rows[i][textField]);
                                        break;
                                    }
                                }
                                if(!find){
                                    var row=$.parseJSON('{"'+idField+'":"'+value+'","'+textField+'":"'+text+'"}');
                                    grid.datagrid('insertRow',{ index: 0,row:row});
                                    $(this).lookup('setText',text);
                                }
                            }catch(e){
                                $(this).lookup('setText',text);
                            }
                        }else{
                            $(this).lookup('setText',text);
                        }
                    }else{
                        $(this).lookup('setText',text);
                    }
                    $(this).lookup('setValue',value);
                }
            }else if(plugin=='combogrid'){
                var oldValue=$(this).combogrid('getValue');
                if(oldValue!=value){
                    if(value!=''){
                        var idField=$(this).combogrid('options').idField;
                        var grid= $(this).combogrid('grid');
                        var rows = grid.datagrid('getRows');
                        var find=false;
                        for(var i=0;i<rows.length;i++){
                            if(rows[i][idField]==value){
                                find=true;
                                break;
                            }
                        }
                        if(!find){
                            var textField=$(this).combogrid('options').textField;
                            var row=$.parseJSON('{"'+idField+'":"'+value+'","'+textField+'":"'+text+'"}');
                            grid.datagrid('insertRow',{ index: 0,row:row});
                        }
                    }
                    $(this).combogrid('setValue',value);
                }
            }else if(plugin=="checkbox"){
                var on=$(this).checkbox('options').on;
                if(on) value=value==on;
                $(this).checkbox('setValue',value).prop("checked",value);
            }else if(plugin=="keywords"){
                if(value!="") $(this).keywords('select',value);
                else $(this).keywords('clearAllSelected');
            }else if(plugin=="datagrid"){
                if(value=='') value=[];
                if(typeof datagrid=='string') value=JSON.parse(value);
                $(this).datagrid('loadData',value);
            }else if(plugin!=""){
                $(this)[plugin].call($(this),'setValue',value,text);
            }else{
                var tagName=$(this).prop("tagName");
                var type=$(this).prop("type");
                if((tagName=='INPUT')&&(type=='checkbox')){
                    var chkVal=$(this).attr('value');
                    if(chkVal){
                        $(this).prop("checked",value==chkVal);
                    }else{
                        $(this).prop("checked",value);
                    }
                }else if((tagName=="INPUT")||(tagName=="TEXTAREA")){
                    $(this).val(value);
                }else if(tagName=="SELECT"){
                    if(!$(this).find("option[value='"+value+"']").size()){
                        $('<option value="'+value+'">'+text+'</option>').prependTo($(this));
                    }
                    $(this).val(value);
                }else{
                    $(this).text(value);
                }
            }
        });
    }
    $.fn.setData = function(data){
        return this.each(function(){
            var plugin=$(this).getPlugin();
            if(['combobox','combogrid','maryselect','datagrid','lookup'].indexOf(plugin)>-1){
                $(this)[plugin].call($(this),'loadData',data);
            }
        });
    }
    $.fn.getValue = function(){
        var value='';
        var plugin=this.getPlugin();
        if(['combobox','combogrid','lookup'].indexOf(plugin)>-1){
            var text=this[plugin].call(this,'getText');
            if(text!=""){
                value=this[plugin].call(this,'getValue');
            }
        }else if(plugin=='checkbox'){
            var opts=this.checkbox('options');
            var on=opts.on,off=opts.off;
            value=this.checkbox('getValue');
            if(on) value=value?on:off;
        }else if(plugin=='keywords'){
            value=this.keywords('getSelected');
        }else if(plugin=='datagrid'){
            value=this.datagrid('getRows');
        }else if(plugin!=''){
            value=$(this)[plugin].call(this,'getValue');
            if((plugin=='numberbox')&&(value!="")&&!isNaN(value)){
                value=parseFloat(value);
            }
        }else{
            var tagName=$(this).prop("tagName");
            var type=$(this).prop("type");
            if((tagName=='INPUT')&&(type=='checkbox')){
                value=this.prop('checked');
                if(value){
                    if(typeof(this.attr('value'))!='undefined')
                        value=this.attr('value');
                }else{
                    if(typeof(this.attr('offval'))!='undefined')
                        value=this.attr('offval');
                }
            }else if((tagName=="INPUT")||(tagName=="TEXTAREA")||(tagName=="SELECT")){
                value=this.val();
            }else{
                value=this.text();
            }
        }
        return value;
    }
    $.fn.getText = function(){
        var text="";
        var plugin=this.getPlugin();
        if(['combobox','combogrid','lookup','maryselect'].indexOf(plugin)>-1){
            text=this[plugin].call(this,'getText');
        }else{
            text=this.getValue();
        }
        return text;
    }
    $.fn.disable = function(){
        return this.each(function(){
            var plugin=$(this).getPlugin();
            if(plugin!=""){
                $(this)[plugin].call($(this),'disable');
            }else{
                $(this).attr("disabled","disabled");
            }
        });
    }
    $.fn.enable = function(){
        return this.each(function(){
            var plugin=$(this).getPlugin();
            if(plugin!=""){
                $(this)[plugin].call($(this),'enable');
            }else{
                $(this).removeAttr("disabled");
            }
        });
    }
})(jQuery);
///表单元素集合的公共赋值与取值
(function(){
    $.fn.setFormData=function(data){
        var $target=this;
        $.each(data,function(key,value){
            if($target.find('#'+key).size()){
                $target.find('#'+key).setValue(value);
            }else if((value!='')&&$target.find('input[name="'+key+'"]').size()){
                $target.find('input[name="'+key+'"]#'+value).radio('setValue',true);
            }
        });
        return $target;
    };
    $.fn.getFormData=function(){
        var data=new Object();
        var radioArr=new Array();
        this.find('[id]').each(function(){
            var id=$(this).attr('id');
            if(id=='') return true;
            if($(this).hasClass('datagrid-row')) return true;
            if(typeof($(this).attr('nosubmit'))!='undefined') return true;
            if($(this).attr('type')=='radio'){  //radio 取值按照name=id
                var name=$(this).attr('name');
                if(name=='') return true;
                if(radioArr.indexOf(name)==-1){
                    radioArr.push(name);
                    data[name]=$("input[name='"+name+"']:checked").attr('id')||'';
                }
            }else{
                data[id]=$(this).getValue();
            }
        });
        return data;
    };
    $.fn.getFormKeys=function(){
        var keys=new Array();
        var radioArr=new Array();
        this.find('[id]').each(function(){
            var id=$(this).attr('id');
            if(id=='') return true;
            if($(this).hasClass('datagrid-row')) return true;
            if(typeof($(this).attr('nosubmit'))!='undefined') return true;
            if($(this).attr('type')=='radio'){  //radio 取值按照name=id
                var name=$(this).attr('name');
                if(name=='') return true;
                if(radioArr.indexOf(name)==-1){
                    radioArr.push(name);
                    keys.push(name);
                }
            }else{
                keys.push(id);
            }
        });
        return keys;
    }
})(jQuery);
//指定元素显示遮罩层
//$(selector).showMask(msg='加载中...');
//$(selector).hideMask();
(function($){
    $.fn.showMask=function(loadMsg){
        if(this.children("div.datagrid-mask").size()) return;
        if(!loadMsg) loadMsg='加载中...';
        this.append("<div class=\"datagrid-mask\" style=\"display:block\"></div>");
        var msg=$("<div class=\"datagrid-mask-msg\" style=\"display:block;left:50%\"></div>").html(loadMsg).appendTo(this);
        msg._outerHeight(40).css({marginLeft:(-msg.outerWidth()/2),lineHeight:(msg.height()+"px")});
    }
    $.fn.hideMask=function(){
        this.find('div.datagrid-mask-msg,div.datagrid-mask').remove();
    }
})(jQuery);
//hisui弹窗 支持对象类型传参(参数按hisui window)，推荐使用基础平台的websys_showModal
function ShowHISUIWindow(title,src,iconCls,width,height)
{
    if(!width) width=900;
    if(!height) height=500;
    if(!$('#_HUI_Model_Win').size()){
        $("body").append("<div id='_HUI_Model_Win' class='hisui-window' style='overflow:hidden;'></div>");
    }
    if((arguments.length==1)&&(typeof arguments[0]=='object')){
        if(typeof websys_writeMWToken=='function') arguments[0].src=websys_writeMWToken(arguments[0].src);
        var opts=$.extend({
            width:width,
            height:height,
            collapsible:false,
            maximizable:false,
            minimizable:false,
            modal:true,
            content:"<iframe width='100%' height='100%' frameborder='0' src='"+arguments[0].src+"'></iframe>"
        },arguments[0]);
    }else{
        if(typeof websys_writeMWToken=='function') src=websys_writeMWToken(src);
        var opts={
            iconCls:iconCls,
            width:width,
            height:height,
            title:title,
            collapsible:false,
            maximizable:false,
            minimizable:false,
            modal:true,
            content:"<iframe width='100%' height='100%' frameborder='0' src='"+src+"'></iframe>"
        };
    }
    return $('#_HUI_Model_Win').window(opts).window('center');
}
function CloseHISUIWindow()
{
    if($('#_HUI_Model_Win').size()){
        $('#_HUI_Model_Win').window('close');
    }
}
//获取datagrid编辑行的index
function GetDGEditRowIndex(target)
{
    if(typeof(target)=='string') target='#'+target;
    var EditRow=$(target).closest("[datagrid-row-index]").attr("datagrid-row-index");
    if(typeof(EditRow)=='undefined') EditRow="";
    return EditRow;
}
//获取treegrid编辑行的RowID
function GetTDGEditRowID(target)
{
    if(typeof(target)=='string') target='#'+target;
    var EditRow=$(target).closest(".datagrid-row[node-id]").attr("node-id");
    if(typeof(EditRow)=='undefined') EditRow="";
    return EditRow;
}
