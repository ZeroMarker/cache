/***
* wanghc --- rewrite pagingToolbar---local data
*2017-10-12 
var pagingBar = new Ext.PagingLocalToolbar({				
	pageSize: this.pageSize, 
	store:ds, 
	displayInfo: true , displayMsg: '{0}-{1},共{2}条',
	items: ['-',new Ext.Toolbar.Button({handler: this.hide,text:'关闭',scope:this})]
});
this.pagingBar.loadAllData(rowData);
**/
(function() {
var T = Ext.Toolbar;
Ext.PagingLocalToolbar = Ext.extend(Ext.Toolbar, {
    /**
     * @cfg {Ext.data.Store} store
     * The {@link Ext.data.Store} the paging toolbar should use as its data source (required).
     */
    /**
     * @cfg {Boolean} displayInfo
     * <tt>true</tt> to display the displayMsg (defaults to <tt>false</tt>)
     */
    /**
     * @cfg {Number} pageSize
     * The number of records to display per page (defaults to <tt>20</tt>)
     */
    pageSize : 20,
    /**
     * @cfg {Boolean} prependButtons
     * <tt>true</tt> to insert any configured <tt>items</tt> <i>before</i> the paging buttons.
     * Defaults to <tt>false</tt>.
     */
    /**
     * @cfg {String} displayMsg
     * The paging status message to display (defaults to <tt>'Displaying {0} - {1} of {2}'</tt>).
     * Note that this string is formatted using the braced numbers <tt>{0}-{2}</tt> as tokens
     * that are replaced by the values for start, end and total respectively. These tokens should
     * be preserved when overriding this string if showing those values is desired.
     */
    displayMsg : 'Displaying {0} - {1} of {2}',
    /**
     * @cfg {String} emptyMsg
     * The message to display when no records are found (defaults to 'No data to display')
     */
    emptyMsg : 'No data to display',
    /**
     * @cfg {String} beforePageText
     * The text displayed before the input item (defaults to <tt>'Page'</tt>).
     */
    beforePageText : 'Page',
    /**
     * @cfg {String} afterPageText
     * Customizable piece of the default paging text (defaults to <tt>'of {0}'</tt>). Note that
     * this string is formatted using <tt>{0}</tt> as a token that is replaced by the number of
     * total pages. This token should be preserved when overriding this string if showing the
     * total page count is desired.
     */
    afterPageText : 'of {0}',
    /**
     * @cfg {String} firstText
     * The quicktip text displayed for the first page button (defaults to <tt>'First Page'</tt>).
     * <b>Note</b>: quick tips must be initialized for the quicktip to show.
     */
    firstText : 'First Page',
    /**
     * @cfg {String} prevText
     * The quicktip text displayed for the previous page button (defaults to <tt>'Previous Page'</tt>).
     * <b>Note</b>: quick tips must be initialized for the quicktip to show.
     */
    prevText : 'Previous Page',
    /**
     * @cfg {String} nextText
     * The quicktip text displayed for the next page button (defaults to <tt>'Next Page'</tt>).
     * <b>Note</b>: quick tips must be initialized for the quicktip to show.
     */
    nextText : 'Next Page',
    /**
     * @cfg {String} lastText
     * The quicktip text displayed for the last page button (defaults to <tt>'Last Page'</tt>).
     * <b>Note</b>: quick tips must be initialized for the quicktip to show.
     */
    lastText : 'Last Page',
    /**
     * @cfg {String} refreshText
     * The quicktip text displayed for the Refresh button (defaults to <tt>'Refresh'</tt>).
     * <b>Note</b>: quick tips must be initialized for the quicktip to show.
     */
    refreshText : 'Refresh',

    /**
     * <p><b>Deprecated</b>. <code>paramNames</code> should be set in the <b>data store</b>
     * (see {@link Ext.data.Store#paramNames}).</p>
     * <br><p>Object mapping of parameter names used for load calls, initially set to:</p>
     * <pre>{start: 'start', limit: 'limit'}</pre>
     * @type Object
     * @property paramNames
     * @deprecated
     */

    /**
     * The number of records to display per page.  See also <tt>{@link #cursor}</tt>.
     * @type Number
     * @property pageSize
     */

    /**
     * Indicator for the record position.  This property might be used to get the active page
     * number for example:<pre><code>
     * // t is reference to the paging toolbar instance
     * var activePage = Math.ceil((t.cursor + t.pageSize) / t.pageSize);
     * </code></pre>
     * @type Number
     * @property cursor
     */
	
	/**
	* wanghc 
	* data===local array data
	* @type Array
	* @property data 
	*/
	/**
	* wanghc 
	* start ====current start row
	* @type int 
	* @property start
	*/
    initComponent : function(){
        var pagingItems = [this.first = new T.Button({
            tooltip: this.firstText,
            overflowText: this.firstText,
            iconCls: 'x-tbar-page-first',
            disabled: true,
            handler: this.moveFirst,
            scope: this
        }), this.prev = new T.Button({
            tooltip: this.prevText,
            overflowText: this.prevText,
            iconCls: 'x-tbar-page-prev',
            disabled: true,
            handler: this.movePrevious,
            scope: this
        }), '-', this.beforePageText,
        this.inputItem = new Ext.form.NumberField({
            cls: 'x-tbar-page-number',
            allowDecimals: false,
            allowNegative: false,
            enableKeyEvents: true,
            selectOnFocus: true,
            submitValue: false,
            listeners: {
                scope: this,
                keydown: this.onPagingKeyDown,
                blur: this.onPagingBlur
            }
        }), this.afterTextItem = new T.TextItem({
            text: String.format(this.afterPageText, 1)
        }), '-', this.next = new T.Button({
            tooltip: this.nextText,
            overflowText: this.nextText,
            iconCls: 'x-tbar-page-next',
            disabled: true,
            handler: this.moveNext,
            scope: this
        }), this.last = new T.Button({
            tooltip: this.lastText,
            overflowText: this.lastText,
            iconCls: 'x-tbar-page-last',
            disabled: true,
            handler: this.moveLast,
            scope: this
        }), '-', this.refresh = new T.Button({
            tooltip: this.refreshText,
            overflowText: this.refreshText,
            iconCls: 'x-tbar-loading',
            handler: this.doRefresh,
            scope: this
        })];


        var userItems = this.items || this.buttons || [];
        if (this.prependButtons) {
            this.items = userItems.concat(pagingItems);
        }else{
            this.items = pagingItems.concat(userItems);
        }
        delete this.buttons;
        if(this.displayInfo){
            this.items.push('->');
            this.items.push(this.displayItem = new T.TextItem({}));
        }
        Ext.PagingLocalToolbar.superclass.initComponent.call(this);
        this.addEvents(
            /**
             * @event change
             * Fires after the active page has been changed.
             * @param {Ext.PagingLocalToolbar} this
             * @param {Object} pageData An object that has these properties:<ul>
             * <li><code>total</code> : Number <div class="sub-desc">The total number of records in the dataset as
             * returned by the server</div></li>
             * <li><code>activePage</code> : Number <div class="sub-desc">The current page number</div></li>
             * <li><code>pages</code> : Number <div class="sub-desc">The total number of pages (calculated from
             * the total number of records in the dataset as returned by the server and the current {@link #pageSize})</div></li>
             * </ul>
             */
            'change',
            /**
             * @event beforechange
             * Fires just before the active page is changed.
             * Return false to prevent the active page from being changed.
             * @param {Ext.PagingLocalToolbar} this
             * @param {Object} params An object hash of the parameters which the PagingLocalToolbar will send when
             * loading the required page. This will contain:<ul>
             * <li><code>start</code> : Number <div class="sub-desc">The starting row number for the next page of records to
             * be retrieved from the server</div></li>
             * <li><code>limit</code> : Number <div class="sub-desc">The number of records to be retrieved from the server</div></li>
             * </ul>
             * <p>(note: the names of the <b>start</b> and <b>limit</b> properties are determined
             * by the store's {@link Ext.data.Store#paramNames paramNames} property.)</p>
             * <p>Parameters may be added as required in the event handler.</p>
             */
            'beforechange'
        );
        this.on('afterlayout', this.onFirstLayout, this, {single: true});
        this.cursor = 0;
        this.bindStore(this.store, true);
    },

    // private
    onFirstLayout : function(){
        if(this.dsLoaded){
            this.onLoad.apply(this, this.dsLoaded);
        }
    },
	// private
	getTotalCount: function(){
		var total = 0;
		if (this.data){
			total = this.data.length;
		}
		return total;
	},
    // private
    updateInfo : function(){
        if(this.displayItem){
            var count = this.store.getCount();
            var msg = count == 0 ?
                this.emptyMsg :
                String.format(
                    this.displayMsg,
                    this.cursor+1, this.cursor+count, this.getTotalCount() //this.store.getTotalCount()
                );
            this.displayItem.setText(msg);
        }
    },
	
    // private
    onLoad : function(store, r, o){
        if(!this.rendered){
            this.dsLoaded = [store, r, o];
            return;
        }
        var p = this.getParams();
        //this.cursor = (o.params && o.params[p.start]) ? o.params[p.start] : 0;
        var d = this.getPageData(), ap = d.activePage, ps = d.pages;

        this.afterTextItem.setText(String.format(this.afterPageText, d.pages));
        this.inputItem.setValue(ap);
        this.first.setDisabled(ap == 1);
        this.prev.setDisabled(ap == 1);
        this.next.setDisabled(ap == ps);
        this.last.setDisabled(ap == ps);
        this.refresh.enable();
        this.updateInfo();
        this.fireEvent('change', this, d);
    },

    // private
    getPageData : function(){
        //var total = this.store.getTotalCount();
		
        // wanghc 
		var total = this.getTotalCount();
		return {
            total : total,
            activePage : Math.ceil((this.cursor+this.pageSize)/this.pageSize),
            pages :  total < this.pageSize ? 1 : Math.ceil(total/this.pageSize)
        };
    },

    /**
     * Change the active page
     * @param {Integer} page The page to display
     */
    changePage : function(page){
       // this.doLoad(((page-1) * this.pageSize).constrain(0, this.store.getTotalCount()));
	   // wanghc 
	   this.doLoad(((page-1) * this.pageSize).constrain(0, this.getTotalCount()));
    },

    // private
    onLoadError : function(){
        if(!this.rendered){
            return;
        }
        this.refresh.enable();
    },

    // private
    readPage : function(d){
        var v = this.inputItem.getValue(), pageNum;
        if (!v || isNaN(pageNum = parseInt(v, 10))) {
            this.inputItem.setValue(d.activePage);
            return false;
        }
        return pageNum;
    },

    onPagingFocus : function(){
        this.inputItem.select();
    },

    //private
    onPagingBlur : function(e){
        this.inputItem.setValue(this.getPageData().activePage);
    },

    // private
    onPagingKeyDown : function(field, e){
        var k = e.getKey(), d = this.getPageData(), pageNum;
        if (k == e.RETURN) {
            e.stopEvent();
            pageNum = this.readPage(d);
            if(pageNum !== false){
                pageNum = Math.min(Math.max(1, pageNum), d.pages) - 1;
                this.doLoad(pageNum * this.pageSize);
            }
        }else if (k == e.HOME || k == e.END){
            e.stopEvent();
            pageNum = k == e.HOME ? 1 : d.pages;
            field.setValue(pageNum);
        }else if (k == e.UP || k == e.PAGEUP || k == e.DOWN || k == e.PAGEDOWN){
            e.stopEvent();
            if((pageNum = this.readPage(d))){
                var increment = e.shiftKey ? 10 : 1;
                if(k == e.DOWN || k == e.PAGEDOWN){
                    increment *= -1;
                }
                pageNum += increment;
                if(pageNum >= 1 & pageNum <= d.pages){
                    field.setValue(pageNum);
                }
            }
        }
    },

    // private
    getParams : function(){
        //retain backwards compat, allow params on the toolbar itself, if they exist.
        // return this.paramNames || this.store.paramNames;
		// wanghc
		return this.paramNames || this.store.paramNames;
    },

    // private
    beforeLoad : function(){
        if(this.rendered && this.refresh){
            this.refresh.disable();
        }
    },

    // private
    doLoad : function(start){		
        var o = {}, pn = this.getParams();
        o[pn.start] = start;
        o[pn.limit] = this.pageSize;
        if(this.fireEvent('beforechange', this, o) !== false){
            //wanghc
			var tmpdata=[];
			for(var ind=0;ind<this.data.length;ind++){
				if ((ind>=start) && (ind<(start+this.pageSize)) ){
					tmpdata.push(this.data[ind]);
				}
			}
			this.cursor = start;
			this.store.loadData(tmpdata);
			//this.store.load({params:o});
        }
    },

    /**
     * Move to the first page, has the same effect as clicking the 'first' button.
     */
    moveFirst : function(){
        this.doLoad(0);
    },

    /**
     * Move to the previous page, has the same effect as clicking the 'previous' button.
     */
    movePrevious : function(){
        this.doLoad(Math.max(0, this.cursor-this.pageSize));
    },

    /**
     * Move to the next page, has the same effect as clicking the 'next' button.
     */
    moveNext : function(){
        this.doLoad(this.cursor+this.pageSize);
    },

    /**
     * Move to the last page, has the same effect as clicking the 'last' button.
     */
    moveLast : function(){
		// wanghc 
		
        var total = this.getTotalCount(); // this.store.getTotalCount(),
            extra = total % this.pageSize;

        this.doLoad(extra ? (total - extra) : total - this.pageSize);
    },

    /**
     * Refresh the current page, has the same effect as clicking the 'refresh' button.
     */
    doRefresh : function(){
        this.doLoad(this.cursor);
    },

    /**
     * Binds the paging toolbar to the specified {@link Ext.data.Store}
     * @param {Store} store The store to bind to this toolbar
     * @param {Boolean} initial (Optional) true to not remove listeners
     */
    bindStore : function(store, initial){
        var doLoad;
        if(!initial && this.store){
            if(store !== this.store && this.store.autoDestroy){
                this.store.destroy();
            }else{
                this.store.un('beforeload', this.beforeLoad, this);
                this.store.un('load', this.onLoad, this);
                this.store.un('exception', this.onLoadError, this);
            }
            if(!store){
                this.store = null;
            }
        }
        if(store){
            store = Ext.StoreMgr.lookup(store);
            store.on({
                scope: this,
                beforeload: this.beforeLoad,
                load: this.onLoad,
                exception: this.onLoadError
            });
            doLoad = true;
        }
        this.store = store;
        if(doLoad){
            this.onLoad(store, null, {});
        }
    },

    /**
     * Unbinds the paging toolbar from the specified {@link Ext.data.Store} <b>(deprecated)</b>
     * @param {Ext.data.Store} store The data store to unbind
     */
    unbind : function(store){
        this.bindStore(null);
    },

    /**
     * Binds the paging toolbar to the specified {@link Ext.data.Store} <b>(deprecated)</b>
     * @param {Ext.data.Store} store The data store to bind
     */
    bind : function(store){
        this.bindStore(store);
    },
    // private
    onDestroy : function(){
        this.bindStore(null);
        Ext.PagingLocalToolbar.superclass.onDestroy.call(this);
    },
	/**
	* load all local data
	*/
	loadAllData:function(data){
		this.data = data;
		this.moveFirst();
	}
});
})();
Ext.reg('paginglocal', Ext.PagingLocalToolbar);

/**
*@author: wanghc
*@author: 2011-11-11
*@name: framework/ext.icare.Lookup.js
*@desc 放大镜改造
*@sample:
var lookup  = new dhcc.icare.Lookup({
	lookupListComponetId: 1872,
	lookupPage: 'dhcdoc.prnordernurse',
	lookupName: 'windTarItemDesc',
	listClassName: 'web.DHCIPBillInsExpItm',
	listQueryName: 'FindTariItem',
	listProperties: [function(){return document.getElementById('windTarItemDesc').value;},""],
	cacheName:"OrderName",    //缓存名
	dataCacheFilter:function(tmpData,qValue,orderId){   
			//过滤缓存数据
			var aliColNum = tmpData[0].length-1;  //别名列号
			var typeColNum = aliColNum-1;
			var rowData = [];
			var domVal = ("^"+qValue).toUpperCase();
			if(orderId){ var rowid=orderId.split("_")[0];}
			if (rowid!=""){
				OrdCatGrp=GetCellData(rowid,"OrdCateGoryRowId");
			}
			Ext.each(tmpData, function(row,ind){
				var MaxRowId = 15;
				var aliName = ("^"+row[aliColNum]).toUpperCase();
				var typeVal = row[typeColNum];
				if (aliName.indexOf(domVal)>-1){
					if ( (OrdCatGrp!=""&&(typeVal==OrdCatGrp)) || (OrdCatGrp=="" && typeVal!="7")){
						if(rowData.length<MaxRowId){
							rowData.push(row);								
						}
					}
					
				}
			});
			return rowData;
		},
});
lookup.doSearch(["aspl",""]);<==>lookup.store.load({params:{P1:"aspl",P2:""}});
* lasterdate: 2012/4/1 加了 displayCM属性 
* 2012/4/18 改了确定位置的方法
*/
Ext.namespace('dhcc.icare');
dhcc.icare.lookupconfig = {
	dsurl:"ext.websys.querydatatrans.csp", 	//生成json的页面
	queryBroker:"ext.websys.QueryBroker", 	//生成cm与store的后台类类名
	readrs:"ReadRSNew2",						//生成cm与store的后台类方法名
	lookupDivId:"bodyLookupComponetId",		//body内的div的id
	lookupDiv:'',							//全局的div dom对象 id为dhcc.icare.lookupconfig.lookupDivId
	preLookup:'',							//上一次的lookup引用
	lookupName:''							//放大镜关联的输入框id
};

function prop(n){return n&&n.constructor==Number?n+'px':n;}
function createLookupBodyDiv(){
	var s ,html;
	dhcc.icare.lookupconfig.lookupDiv = document.createElement("div");
	dhcc.icare.lookupconfig.lookupDiv.id = dhcc.icare.lookupconfig.lookupDivId ;
	dhcc.icare.lookupconfig.lookupDiv.style.display = "none";
	dhcc.icare.lookupconfig.lookupDiv.style.zIndex = 12000;	
	dhcc.icare.lookupconfig.lookupDiv.style.position = "absolute";
	dhcc.icare.lookupconfig.lookupDiv.style.borderStyle = 'outset';
	dhcc.icare.lookupconfig.lookupDiv.style.borderWidth = '2px';
	dhcc.icare.lookupconfig.lookupDiv.style.borderColor = '#a3bae9';

	document.body.appendChild(dhcc.icare.lookupconfig.lookupDiv);
	if(Ext.isIE6){
		s = {top:'auto',left:'auto',width:'auto',height:'auto',opacity:true,src:'javascript:false;'};
		html= '<iframe class="bgiframe"frameborder="0"tabindex="-1"src="'+s.src+'"'+
	                   'style="display:block;position:absolute;z-index:-1;'+
	                       (s.opacity !== false?'filter:Alpha(Opacity=\'0\');':'')+
	                       'top:'+(s.top=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderTopWidth)||0)*-1)+\'px\')':prop(s.top))+';'+
	                       'left:'+(s.left=='auto'?'expression(((parseInt(this.parentNode.currentStyle.borderLeftWidth)||0)*-1)+\'px\')':prop(s.left))+';'+
	                       'width:'+(s.width=='auto'?'expression(this.parentNode.offsetWidth+\'px\')':prop(s.width))+';'+
	                       'height:'+(s.height=='auto'?'expression(this.parentNode.offsetHeight+\'px\')':prop(s.height))+';'+
	                '"/>';
		dhcc.icare.lookupconfig.lookupDiv.insertBefore(document.createElement(html));
	}
	var extStyle = document.createElement("style");
	extStyle.type = "text/css";
	extStyle.id = dhcc.icare.lookupconfig.lookupDivId+"extStyle";
	document.body.appendChild(extStyle);
	extStyle="";
	Ext.grid.GridView.prototype.getCellIndex = function(el){
		if(el){
		    var m = el.className.match(this.colRe);
		    if(m && m[1] && this.cm){ //2017-1-23 this.cm
		        return this.cm.getIndexById(m[1]);
		    }
		}
		return false;
	};
	Ext.EventManager.on(document.body,"mousedown",function(e){
		var height = Ext.getBody().getHeight() - 30;
		var width = Ext.getBody().getWidth() - 30;
		if (e.xy[1]>height)return ; //ie8下点滚动条
		if (e.xy[0]>width)return;
		if (e.target){
			if(e.target.id.indexOf(dhcc.icare.lookupconfig.lookupName)>-1){
				return false;
			}
			var tmp = e.target;
			var maxTimes=20;	
			while(tmp){
				if(tmp.id && tmp.id==dhcc.icare.lookupconfig.lookupDivId){return false;}
				if(tmp.tagName=="BODY"){
					dhcc.icare.lookupconfig.lookupDiv.style.display = "none"; //add 2012/07/01
					try{
	    					dhcc.icare.lookupconfig.preLookup.hide();
		    			}catch(e){}
	    			dhcc.icare.lookupconfig.preLookup = '';
					return false;
				}	
				tmp = tmp.parentElement;
				maxTimes--;
				if(maxTimes==1) return ;
			}
		}
	})
}
Ext.onReady(createLookupBodyDiv);
//lookup id = this.lookupName+"zlookup"
dhcc.icare.Lookup = Ext.extend(Ext.grid.GridPanel, {  
    /**
    * @cfg {String} lookupListComponetId websys.Lookup.List组件对应的ID 如:1872
    * 在自定义列布局用到
    * 如果值为websys.Lookup.List组件对应的ID,则双击列头会出现自定义界面
    */
    /**
    * @cfg {String} lookup PageName Or componentName
    * 在查询时作为request传到后台
    */
    lookupPage: '',
    /**
    * @cfg {String} Lookup name
    *关联到的输入框的名字  
    */
    lookupName: '',
    /**
	* @cfg {String}  listClassName 后台Query类名
	* 与listQueryName一起生成cm与store
	*/
    listClassName: '',
    /**
    * @cfg {String} listQueryName 后台Query名字
    * 与listClassName一起生成cm与store
    */
    listQueryName: '',
    /**
	* @cfg {Array} listProperties 后台Query的参数
    */
    listProperties: [],
    /**
    * @cfg {Boolean} resizeColumn 是否加载完Store后重新计算列宽. default false.
    * 这个属性会强制性重新描绘lookup
    */
    resizeColumn : false ,
    /**
    * @cfg {String} displayField 显示到输入文本框中的字段名 默认为Query第一列名,显示store列名
    */
    /**
    * @cfg {Array} displayCM grid显示的列名集合 默认是通过后台query产生
    * sample :
    *后台 query包含多个字段现只要显示描述 displayCM: ['arcim']
    */
    viewConfig:{forceFit:true},
	
    defaultHeight : 268,
	/**
	* @cfg {int} minHeight 放大镜的最小高度. 默认90.
	*/
    minHeight : 90,
	/**
	* @cfg {int} maxHeight 放大镜的最大高度. 默认360.
	*/	
	maxHeight : 360,
	/**
    * @cfg {Boolean} isDynamicHeight 默认为false. grid高度随数据条数变化.
    */
    isDynamicHeight : false,
    /**
    * @cfg {int} rowHeight 行的高度. 默认一行30px, 用来计算dynamicHeight.
    */
    rowHeight: 30,
    /**
    * @cfg {Boolean} rowNumber 显示行号列 默认false. 
    */
    rowNumber : false,   
    /**
    * @cfg {Boolean}  enableLoadedFocus 加载完数据后光标到放大镜 默认true
    */
	enableLoadedFocus:true,
    /**
    * @cfg {Boolean} isCombo 是不是实时查询 默认false.
    */
    isCombo : false,   
    /**
    * @cfg {int} queryDelay 在isCombo为true时, 延迟查询豪秒数.
    */
    queryDelay : 200,  
    /**
    * @cfg {int} minLen 在isCombo为true时，最小查询长度. 大于等于minLen才查询.
    */
    minLen : 0,  
    /** @private  当前结果集对应 的 输入框值 */ 
	qvalue : "",
	
	/**
	* @cfg {Boolean} enableNumberEvent 启用数字选行 默认false
	* @other 2017-3-21 修改 江苏中医院
	* 当按数字n键时选中第n行记录
	*/
	/**
	* @other 2017-3-21 南方医院, 按Up到第一行后,再按则到最后行. 按Down到最后行后,再按则到第一行.
	*/
	enableNumberEvent : false,
	/**
	* private var
	* top.gCacheData[top.CacheOrderName]中有数据则,走缓存
	* @cfg {Boolean} enableCache 启用缓存数据 默认false
	* @other 2017-5-31 南方医院
	* 医嘱录入医嘱项缓存到头菜单上, 头菜单加载完成后发请求拿所有的医嘱项
	* 放大镜再从缓存中过滤数据
	*/
	enableCache:false,
	/**
	*@cfg {String} cacheName 缓存名称
	*/
	cacheName:"",
	/**
	* @method selectRowRender 选中行时调用该方法返回html
	*/
	/**
	* @method dataCacheFilter(tmpData,qValue,orderId) 数据缓存过滤
	*/
	/**
	* @cfg {Array} pagingBarItems 翻页条上的工具数组
	**/
	pagingBarItems:[],
    initComponent: function() {
    	if(dhcc.icare.lookupconfig.preLookup) dhcc.icare.lookupconfig.preLookup.hide();
    	dhcc.icare.lookupconfig.lookupDiv.innerHTML = "";
        this.initGridPanel();
        dhcc.icare.Lookup.superclass.initComponent.call(this);
        dhcc.icare.lookupconfig.lookupName = this.lookupName
        //if (this.isCombo){
        this.dqTask = new Ext.util.DelayedTask(this.doSearch, this);
        //}
        this.addEvents(    
		/**
		 * @event selectRow
		 * 选中行数据后,触发SelectRow事件
		 * @param {String} 行数据串col1^col2^col3
		 */	
		'selectRow',
	     /**
		 * @event lookupLoaded
		 * 放大镜数据加载完成后,触发lookupLoaded事件
		 * @param {dhcc.icare.Lookup} obj  当前放大镜
		 * @param {records} records  数据集
		 * @param {Object} options   
		 */	
		 'lookupLoaded');
        //if(window.console) console.log("initComponent   end" + new Date());	    
    },   
	initGridPanel: function (){
		if(!this.lookupName) return;
		var myclassname = this.listClassName;
		var myqueryname = this.listQueryName;
		if ( myclassname == '' || myqueryname == '')  return ;
		//if(window.console) console.log("initGridPanel start" + new Date());
		var myCmAndFields = tkMakeServerCall ( dhcc.icare.lookupconfig.queryBroker, dhcc.icare.lookupconfig.readrs, myclassname, myqueryname );				
		//if(window.console) console.log("initGridPanel   end" + new Date());
		var json = Ext.decode( myCmAndFields );
		/// 当前Lookup开启缓存,且缓存中有数据, 1_OrderName,2_OrderName
		// if this.lookupName==top.CacheOrderName
		var _cahceName_ = this.cacheName;
		if ("undefined"==typeof _cahceName_ || ""==_cahceName_){
		}else{
			if ("undefined"==typeof gCacheData){ gCacheData = {}}
			if (top.gCacheData && top.gCacheData[_cahceName_]){ 		/// 头菜单有缓存
				window.gCacheData[_cahceName_] = top.gCacheData[_cahceName_]; //缓存放当前界面
			}else{
				if ("undefined" == typeof top.gCacheDetails) {
					var tmpCacheDetails = tkMakeServerCall("websys.DHCCache","CacheDetails",session["LOGON.GROUPID"],session["LOGON.CTLOCID"],session["LOGON.USERID"]);				
					try{
						window.gCacheDetails = Ext.decode( tmpCacheDetails );
					}catch(e){console.log("放大镜报错:"+e);}
				}else{
					window.gCacheDetails = top.gCacheDetails;
				}		
				if (window.gCacheDetails[_cahceName_] && "undefined"==typeof gCacheData[_cahceName_]){
						var xhr = cspFindXMLHttp();
						xhr.open("GET",gCacheDetails[_cahceName_],false);
						xhr.send(); //'r='+new Date().getTime());
						if(xhr.readyState == 4){	
							try{
								if(xhr.status >= 200 && xhr.status < 300){
									window.gCacheData[_cahceName_] = Ext.decode( xhr.responseText);
								}
							}catch(e){}
						}
				}
			}
			if (gCacheData[_cahceName_]){
				this.enableCache=true;
			}else{
				this.enableCache=false;
			}
		}
		/*
		if (top.CacheOrderName && top.CacheOrderName==this.cacheName) { //this.listClassName=="web.DHCDocOrderEntry" && this.listQueryName=="LookUpItem"){
			if ( top.gCacheData && top.gCacheData[top.CacheOrderName]) this.enableCache=true;
		}*/
		/*增加关闭按钮*/

		var _pagingBarItems;
		if (Ext.isArray(this.pagingBarItems)) {
			_pagingBarItems = Ext.apply([],this.pagingBarItems);
			_pagingBarItems.push("-");
			//this.pagingBarItems.push(new Ext.Toolbar.Button({handler: this.hide,text:'关闭',scope:this}));
			_pagingBarItems.push({handler: this.hide,text:'关闭',scope:this,xtype:"tbbutton"});
		}
		if (!!this.enableCache){
			var ds = new Ext.data.ArrayStore ({
				data: [], 
				fields: json.fns, 
				listeners:{scope: this,load: this.storeLoaded}
	    	});
	    	this.pageSize = this.pageSize || json.pageSize || 15;
			var pagingBar = new Ext.PagingLocalToolbar({				
				pageSize: this.pageSize, 
				store:ds, 
				displayInfo: true , displayMsg: '{0}-{1},共{2}条',
				items: _pagingBarItems
	    	});
	    	this.queryDelay = 40;
		}else{
			var ds = new Ext.data.JsonStore ({
				url: dhcc.icare.lookupconfig.dsurl, 
				root: "record", 
				totalProperty: "total", 
				fields: json.fns, 
				listeners:{scope: this,load: this.storeLoaded}
	    	});
	    	this.pageSize = this.pageSize || json.pageSize || 15;
			var pagingBar = new Ext.PagingToolbar({
				pageSize: this.pageSize, store: ds, displayInfo: true , displayMsg: '{0}-{1},共{2}条',
				items: _pagingBarItems
	    	});
		}
    	var cms = json.cms;
		var styleObj = document.getElementById(dhcc.icare.lookupconfig.lookupDivId+"extStyle");
		if(json.fontSize){
			var bubbleCssStyle = ".x-grid3-row td, .x-grid3-summary-row td {font: normal "+json.fontSize+"px arial, tahoma, helvetica, sans-serif;} .x-grid3-hd-row td {font: normal "+json.fontSize+"px arial, tahoma, helvetica, sans-serif;}";
			if (Ext.isIE8 || Ext.isIE7 || Ext.isIE6){
				//window.bc_bubble_css = bubbleCssStyle;
				var styleSheetLast = document.styleSheets[document.styleSheets.length-1];
				/*if(styleSheetLast.cssRules && styleSheetLast.cssRules.length==2){
					styleSheetLast.deleteRule(0);
					styleSheetLast.deleteRule(1);
				}*/
				if (styleSheetLast.cssText){
					styleSheetLast.cssText="";
				}
				styleSheetLast.addRule(".x-grid3-row td","font: normal "+json.fontSize+"px arial, tahoma, helvetica, sans-serif;",0);
				styleSheetLast.addRule(".x-grid3-hd-row td","font: normal "+json.fontSize+"px arial, tahoma, helvetica, sans-serif;",1);
				//document.createStyleSheet("javascript:bc_bubble_css");
			}else{
				styleObj.innerHTML = bubbleCssStyle;
			}		
		}
    	var cmslen = 0; 
    	if(this.displayCM && this.displayCM["indexOf"] ){
	    	cmslen = cms.length;
	    	for(var i=0;i< cmslen; i++){
		    	if(this.displayCM.indexOf(cms[i].dataIndex)>-1){
			    	cms[i].hidden = false;
			    }else{
				  	cms[i].hidden = true;
				 }	
		    }
		}
    	   	
    	var cmslen = cms.length;
    	var displayFieldCmCount = 0;
    	for(var i = 0 ; i < cmslen ; i++){
	    	if(!cms[i].hidden){
		    	if (!this.displayField) this.displayField = json.fns[i].name;		    			   
				displayFieldCmCount++;
			}
	    }
		this.id = this.lookupName+"zlookup";
		this.title = "";				
		this.width= this.width || (((displayFieldCmCount*140) > document.body.clientWidth) ? document.body.clientWidth : displayFieldCmCount*140);
		if(this.width<420) this.width=420;		
		this.height = this.defaultHeight;
		if (this.rowNumber) cms.splice(0,0,new Ext.grid.RowNumberer());
		this.colModel = new Ext.grid.ColumnModel({columns:cms,defaults:{sortable:false,menuDisabled:true}});
		this.store = ds;
		var myloadM;
		if (Ext.isIE){
			myloadM = new Ext.LoadMask(dhcc.icare.lookupconfig.lookupDiv, {msg:"正在加载数据...",store:this.store});//this.loadMask = myloadM;
		}else{
			myloadM = true;
		}
		this.stripeRows=true;
		this.border=false;
		this.bbar = pagingBar;
		this.pagingBar = pagingBar;
		this.listeners = {
			afterrender: this.searchAndShow,
			headerdblclick: this.headerDblClick, 
			rowclick: this.rowClick,
			keydown: this.gridPanelKeydown,
			scope: this
		};
		//Ext.EventManager.addListener(window,"resize", function(){});
		this.renderTo = dhcc.icare.lookupconfig.lookupDivId;
		var lookupDom = document.getElementById(this.lookupName);
		Ext.EventManager.on(lookupDom,"keydown",this.srcDomKeyupHandler,this);
	},
	/* 	getOffset : function(o){
		var ntLeft = o.offsetLeft ;
		var ntTop = o.offsetTop + o.offsetHeight ;
		var width = o.offsetWidth;
		var height = o.offsetHeight		
		while(o = o.offsetParent){
			ntLeft += o.offsetLeft;
			ntTop += o.offsetTop;
		}		
		return [ntLeft,ntTop,width,height];		
	}, */
	getOffset : function(){
		var el = Ext.get(this.lookupName);
		var extxy = el.getAnchorXY();
		var width = el.dom.offsetWidth;
		var height = el.dom.offsetHeight		
		return [extxy[0],extxy[1]+height,width,height];		
	},
	searchAndShow: function(param){
		dhcc.icare.lookupconfig.preLookup = this;
		this.posiAndSizeResize();	
		this.show();
		/*医嘱录入界面第一次打开放大镜进入该方法*/
		//this.doSearch(param);/* 减少不必要的请求 2018-07-20 by wanghc 查询统一走task*/
		if(this.dqTask){
			this.dqTask.delay(this.queryDelay);
		}
		if(Ext.isIE) setTimeout(function(){CollectGarbage()},10); 
	},
	posiAndSizeResize: function(){		
		var xy = this.getOffset(); //[left, top, width, height]
		var bodyHeight = document.body.clientHeight; // window.screen.height ;
		var bodyWidth = document.body.clientWidth; // window.screen.width ;
		//var topBlank = xy[1] - xy[3];
		//var bottomBlank = bodyHeight - xy[1];
		var height = this.defaultHeight;
		var width = this.width;
		//决定top
		/* if((bodyHeight-height-xy[1]<0)){	//下面不能显示
			if (xy[1]-xy[3]>height){		//上面能显示
				dhcc.icare.lookupconfig.lookupDiv.style.pixelBottom = bottomBlank + xy[3];		
			}else {
				if(topBlank>bottomBlank){
					height = topBlank;
					dhcc.icare.lookupconfig.lookupDiv.style.pixelBottom = bottomBlank + xy[3];		
				}else{
					height = bottomBlank;
					dhcc.icare.lookupconfig.lookupDiv.style.pixelTop = xy[1];
				}
			}
		}else{			
			dhcc.icare.lookupconfig.lookupDiv.style.pixelTop = xy[1];
		}		 */
		var tmpLeft = xy[0];
		var tmpTop = xy[1];
		if (((bodyHeight-tmpTop) < height) && ( (xy[1]-xy[3]) > height )){					//下面不能显示,但上面能显示
			tmpTop = xy[1]  - xy[3] - height - 3;
		}
		if ( ((bodyWidth-tmpLeft)<width) && ((xy[0]+xy[2])>width) ){	//右边不能显示,但左边能显示			
			tmpLeft = bodyWidth - width - (bodyWidth-xy[0]-xy[2]);		//减放大镜的宽度,再减文本框右边空白宽度
		}
		dhcc.icare.lookupconfig.lookupDiv.style.top = tmpTop +"px"; 
		dhcc.icare.lookupconfig.lookupDiv.style.left = tmpLeft +"px" ; 
		dhcc.icare.lookupconfig.lookupDiv.style.display = "";
		//this.setHeight(height);
	},
	headerDblClick: function(){
		if(this.lookupListComponetId != ""){
			var flag = tkMakeServerCall("web.SSGroup","GetAllowWebColumnManager",session['LOGON.GROUPID']);
			if(flag==1) websys_lu('../csp/websys.component.customiselayout.csp?ID='+this.lookupListComponetId+'&CONTEXT=K'+this.listClassName+':'+this.listQueryName,false);		//+"&DHCICARE=1" wanghc 2018-1-3 实现列顺序功能
		}
	},
	/*处理生成行信息*/
	selectRowRenderFn:function(r){
		if (Ext.isFunction(this.selectRowRender)){
			var _this_=this;
			
			var ludiv = Ext.get(dhcc.icare.lookupconfig.lookupDivId);
			if (ludiv.last().id !== this.lookupName+"zlookup"){
				ludiv.last().remove();
			}
			ludiv.createChild({
				tag:"div",
				html:_this_.selectRowRender.call(_this_, r)
			});
		}	
	},
    rowClick: function(gridPanel, rowIndex, e) {
        var r = this.store.getAt(rowIndex);
        if (r){      
	        this.value = r.data[this.displayField];
	        document.getElementById(this.lookupName).value = this.value;
	        var arr = this.store.fields.keys;
	        var len = arr.length;
	        var str = "";
	        for(var i = 0 ; i < len ; i++){
		    	   if(str=="")str = r.data[arr[i]];
		    	   else{str += "^"+r.data[arr[i]];}
		    }
		    //websys_nextfocusElement($(this.lookupName));	    
		    //websys_setfocus(this.lookupName);
	        /*this.fireEvent('selectRow',str);              
	        this.hide();*/
	        var rtn = this.fireEvent('selectRow',str);  
	        if (undefined == rtn || true==rtn){ //如果返回false则不关闭放大镜
		        this.hide();
		    }
        }
    },
    hide:function(){
	    var lookupDom = document.getElementById(this.lookupName);		
	    Ext.EventManager.un(lookupDom,"keydown",this.srcDomKeyupHandler,this); /*事件remove 2018-07-20 by wanghc*/
	    dhcc.icare.lookupconfig.lookupDiv.style.display = "none"; //add 2012/07/01
	    dhcc.icare.lookupconfig.preLookup = '';
	    if(this.dqTask){
			this.dqTask.cancel();
			this.dqTask = null;
	    }
	    this.destroy();
	},
    getValue: function() {
	    this.value;       
    },
    doSearch: function(param) {
	    var dom = document.getElementById(this.lookupName);
	    var arr = this.listProperties ;
	    if(arguments.length>0 && param instanceof Array) arr = param;
	    var len = arr.length;
	    var obj={};
	    obj.lookupName = this.lookupName;
	    obj.lookupPage = this.lookupPage;
	    obj.pClassName = this.listClassName;
	    obj.pClassQuery = this.listQueryName;
	    obj.start = 0;
	    obj.limit = this.pageSize;
	    if(len>0){
	    	for(var i = 0 ; i< len ; i++){
	    		if(Ext.isFunction(arr[i])){
	    			obj["P"+(i+1)]=arr[i]();
	    		}else{
		    		obj["P"+(i+1)]=arr[i];
		    	}
	    	}	    	
	    }
		if ( dom.value.length >= this.minLen && dom.value!==this.qValue){ /*最后一次查询与当前查询条件一样时不查询 2018-07-20 by wanghc*/
			if (this.store){
				this.store.baseParams = obj;
				this.qValue = dom.value ;
				if (!!this.enableCache){ //json
					var _this_ = this;
					var tmpData = gCacheData[this.cacheName];
					if (tmpData.length>0){
						var rowData=[];
						if (_this_.dataCacheFilter){
							rowData = _this_.dataCacheFilter(tmpData,dom.value);
						}else{
							var aliColNum = tmpData[0].length-1;  //别名列号
							var rowData = [];
							var domVal = ("^"+dom.value).toUpperCase();
							Ext.each(tmpData, function(row,ind){
								var aliName = ("^"+row[aliColNum]).toUpperCase();
								if (aliName.indexOf(domVal)>-1){
									if(rowData.length<15){
										rowData.push(row);
									}
								}
							});
						}
						if (Ext.isArray(rowData)){
							if(this.qValue==document.getElementById(this.lookupName).value)  {
								//this.store.loadData(rowData);
								this.pagingBar.loadAllData(rowData);
								//this.pageSize = rowData.length;
							}
						}
					}
				}else{ //csp
					this.store.load();
				}
			}
		}
    }, 
    resizeColumnFun : function(s,rs,obj){
	    if (rs.length==0){ return ;} //没数据
		var pagesize,cm,objWidth = {};
		if(this.resizeColumn && this.colModel){
			pagesize = 0;
			cm = this.colModel ;
			for(var cm_i=0; cm_i<cm.config.length; cm_i++){
				if (cm.config[cm_i].hidden) continue;
				
				objWidth.key = cm.config[cm_i].dataIndex;
				if (objWidth.key=="") continue;				
				objWidth.val = cm.config[cm_i].width;				
				//objWidth.val = 60 ;
				for(var rs_i=0;rs_i<rs.length;rs_i++){
					var len = rs[rs_i].get(objWidth.key).trim().replace(/[^\x00-\xff]/g,"**").length * 7 + 15; //wanghc 10px
					if (len > objWidth.val){
						objWidth.val = len ;
					}
				}				
				cm.config[cm_i].width = objWidth.val;
				pagesize += objWidth.val;
		  	}
		  	this.setWidth(pagesize+20);
		  	this.reconfigure(this.store, cm);		  	
		}
		if (this.isDynamicHeight){
			var height = rs.length * this.rowHeight + 60;
			this.defaultHeight = this.minHeight ; 
			if (this.minHeight < height){ this.defaultHeight = height;}
			if (this.defaultHeight > this.maxHeight) { this.defaultHeight = this.maxHeight; }
			this.setHeight(this.defaultHeight);
		}
	},      
    storeLoaded: function(obj,records,options){
		if (this.store){
			this.resizeColumnFun(obj,records,options);
			this.posiAndSizeResize();
			this.getSelectionModel().selectFirstRow();
			//显示出第一行层信息
			this.selectRowRenderFn(this.store.getAt(0));
			//2018-1-3 view选中第一行
			var view = this.getView();
			view.syncFocusEl(view.ensureVisible(0, 0, false));
			if (this.enableLoadedFocus){
				if (!this.isCombo){
					this.getView().focusRow(0);
				}else{ //2017-6-5 isCombo时焦点得到输入框中, 鼠标翻页后,光标转走,快捷键失效
					var dom = document.getElementById(this.lookupName);
					dom.focus();
				}
			}
			this.fireEvent("lookupLoaded",obj,records,options)
		}
    },
	NextRow : function(){
		var _this_ = this;
		var sm = this.getSelectionModel();
		var view=this.getView();
		var ind = 0;
		if (sm.hasNext()){
			ind = parseInt(sm.last)+1;
		}else{
			ind = 0;
			//sm.selectFirstRow();
			//view.syncFocusEl(view.ensureVisible(0, 0, false));
		}
		sm.selectRow(ind);
		view.syncFocusEl(view.ensureVisible(ind, 0, false));
		this.selectRowRenderFn(_this_.store.getAt(ind));
	},
	PreRow:function(){
		var _this_ = this;
		var sm = this.getSelectionModel();
		var view = this.getView();
		var ind = 0;
		if(sm.hasPrevious()) { 
			ind = parseInt(sm.last)-1;
		}else{
			ind = this.store.getCount()-1;
			//sm.selectLastRow();
			//view.syncFocusEl(view.ensureVisible(ind, 0, false));			
		}
		sm.selectRow(ind);
		view.syncFocusEl(view.ensureVisible(ind, 0, false));
		this.selectRowRenderFn(_this_.store.getAt(ind));
	},
    /**
     * 侦听GridPanel的keydown事件。按下ENTER键后选中行，按下ESC键收起GridPanel。
     */
    gridPanelKeydown: function(e) {
    	e.stopEvent();
		var key = e.getKey(); 
    	var obj = document.getElementById(this.lookupName);
    	if((key == e.ENTER) || (key == e.SPACE)) {
    		var record = this.getSelectionModel().getSelected();
			if (this.store){
				this.rowClick(this, this.store.indexOf(record));
			}
    	}else if(key == e.ESC) {
        	this.hide();        	
        	if(obj && !obj.disabled && !obj.readOnly) {	        	
	        	websys_setfocus(this.lookupName);
        	}
        }else if (key == Ext.EventObject.PAGE_DOWN){			
			if (this.pagingBar.getPageData().activePage< this.pagingBar.getPageData().pages){
				this.pagingBar.moveNext();
			}
		}else if (key == Ext.EventObject.PAGE_UP){
			if (this.pagingBar.getPageData().activePage>1){
				this.pagingBar.movePrevious();
			}
		}else if(key == Ext.EventObject.BACKSPACE){
			if(obj && !obj.disabled && !obj.readOnly) {
				this.getSelectionModel().clearSelections();
				websys_setfocus(this.lookupName);			
			}
		}else if(key == Ext.EventObject.UP){
			if(!this.getSelectionModel().hasPrevious()){
				this.getSelectionModel().last = this.store.getCount();
				//this.getSelectionModel().selectLastRow();
				//this.grid.getView().focusRow(this.getSelectionModel().last);
				//websys_setfocus(this.lookupName);
			}
		}else if(key == Ext.EventObject.DOWN){
			if(!this.getSelectionModel().hasNext()){
				this.getSelectionModel().last = -1;  //RowSelectionModel--处理down事件
				//this.getSelectionModel().selectFirstRow();
				//this.grid.getView().focusRow(this.getSelectionModel().last);
			}
		}else if (e.shiftKey || e.ctrlKey || e.altKey){
			
		}else if (this.enableNumberEvent) {
			if (key<=57 && key >=49){ // 1=49
				this.rowClick(this, key-49);   // rowClick(t,rowNumber) 第二个入参0表示第一行
				return false;
			}else if (key<=105 && key>=97) {  // 小键盘1=97
				this.rowClick(this, key-97);
				return false;
			}
		}
        //e.preventDefault() : 
        //e.stopPropagation(); // 取消事件冒泡，避免可能影响其它组件的keyDown事件，例如Button设置了快捷键Enter  
    },
	srcDomKeyupHandler:function(e){
		if (!this) return false;
		if (!this.store) return false;
		var key = e.getKey();
		var obj = document.getElementById(this.lookupName);
		if( [Ext.EventObject.ENTER,
			Ext.EventObject.PAGE_UP,
			Ext.EventObject.PAGE_DOWN,
			Ext.EventObject.UP,
			Ext.EventObject.PAGE_DOWN].indexOf(key)>-1){
			/*cancel bubble*/
			e.stopEvent();
			e.preventDefault();
			e.stopPropagation();
		}
		if ((e.shiftKey || e.ctrlKey || e.altKey)){
			//!@#$%^&*(     --->not stop event
		}else{
			if ( this.enableNumberEvent && ((key<=105 && key>=97) || (key<=57 && key >=49)) ){
				e.stopEvent();
				e.preventDefault();
				e.stopPropagation();
			}
		}
    	if ((key == e.ENTER)){
			if ((this.isCombo) && obj.value == this.qValue) {
				// 查询结果与查询条件一致才上屏
				// isCombo 或 空格 时上屏 
				// 回车不能直接上屏, 输入框中回车有时是弹出放大镜
				var record = this.getSelectionModel().getSelected();
				//2018-1-3 放大镜显示且回车则选中
				if (this.store && dhcc.icare.lookupconfig.lookupDiv.style.display!=="none"){
					this.rowClick(this, this.store.indexOf(record));
				}
			}else{
				this.searchAndShow();
			}
    	}else if(key == e.ESC) {
        	this.hide();        	
        	if(obj && !obj.disabled && !obj.readOnly) {	        	
	        	//websys_setfocus(this.lookupName);
        	}
        }else if(key == Ext.EventObject.DOWN){
			this.NextRow();
			//this.getSelectionModel().selectNext(); --focusview
			//this.getSelectionModel().selectRow(2)
		}else if(key == Ext.EventObject.UP){
			this.PreRow();
			//this.getSelectionModel().selectPrevious();
		}else if (key == Ext.EventObject.PAGE_DOWN){			
			if (this.pagingBar.getPageData().activePage< this.pagingBar.getPageData().pages){
				this.pagingBar.moveNext();
			}
		}else if (key == Ext.EventObject.PAGE_UP){
			if (this.pagingBar.getPageData().activePage>1){
				this.pagingBar.movePrevious();
			}
		}else if(key == Ext.EventObject.LEFT){
			
		}else if(key == Ext.EventObject.RIGHT){
			
		}else if (e.shiftKey || e.ctrlKey || e.altKey){
			
		}else{
			if (this.isCombo && this.enableNumberEvent) {
				if (key<=57 && key >=49){ // 1=49
					this.rowClick(this, key-49);   // rowClick(t,rowNumber) 第二个入参0表示第一行
					return false;
				}else if (key<=105 && key>=97) {  // 小键盘1=97
					this.rowClick(this, key-97);
					return false;
				}
			}
			if ( this.isCombo && obj.value.length >= this.minLen){
				this.dqTask.cancel();
				this.dqTask.delay(this.queryDelay);
			}
			//this.searchAndShow();
		}
		return false;
	}
});