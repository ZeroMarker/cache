Ext.ns('Ext.ux.grid');

Ext.ux.grid.GridSummary = function(config) {
	Ext.apply(this, config);
};

Ext.extend(Ext.ux.grid.GridSummary, Ext.util.Observable, {
	summaryTitle : '合计:',
	init : function(grid) {
		this.grid = grid;
		this.cm = grid.getColumnModel();
		this.view = grid.getView();
		var v = this.view;
		
		// override GridView's onLayout() method
		v.onLayout = this.onLayout;
		
		v.afterMethod('render', this.refreshSummary, this);
		v.afterMethod('refresh', this.refreshSummary, this);
		v.afterMethod('onColumnWidthUpdated', this.doWidth, this);
		v.afterMethod('onAllColumnWidthsUpdated', this.doAllWidths, this);
		v.afterMethod('onColumnHiddenUpdated', this.doHidden, this);
		Ext.EventManager.onWindowResize(this.onWinResize,this);
		
		grid.on({
			afteredit:this.refreshSummary,
			scope: this
		});
		// update summary row on store's add/remove/clear/update events
		grid.store.on({
			add: this.refreshSummary,
			remove: this.refreshSummary,
			clear: this.refreshSummary,
			update: this.refreshSummary,
			load:this.onLoad,
			scope: this
		});

		if (!this.rowTpl) {
			this.rowTpl = new Ext.Template(
				'<div class="x-grid3-summary-row">',
					'<table class="x-grid3-summary-table" border="0" cellspacing="0" cellpadding="0" style="{tstyle}">',
 						'<tbody><tr>{cells}</tr></tbody>',
					'</table>',
				'</div>'
			);
			this.rowTpl.disableFormats = true;
		}
		this.rowTpl.compile();

		if (!this.cellTpl) {
			this.cellTpl = new Ext.Template(
				'<td class="x-grid3-col x-grid3-cell x-grid3-td-{id} {css}" style="{style}">',
					'<div class="x-grid3-cell-inner x-grid3-col-{id}" unselectable="on" {attr}>{value}</div>',
				"</td>"
			);
			this.cellTpl.disableFormats = true;
		}
		this.cellTpl.compile();
	},
	calculate : function(rs, cm) {
		var data = {}, cfg = cm.config;
		// loop through all columns in ColumnModel
		for (var i = 0, len = cfg.length; i < len; i++) {
			var cf = cfg[i], // get column's configuration
				cname = cf.dataIndex; // get column dataIndex
			// initialise grid summary row data for the current column being
			// worked on
			data[cname] = 0;
			if (cf.summaryType) {
				for (var j = 0, jlen = rs.length; j < jlen; j++) {
					var r = rs[j]; // get a single Record
					data[cname] = Ext.ux.grid.GridSummary.Calculations[cf.summaryType](r.get(cname), r, cname, data, j);
				}
			}
		}
		return data;
	},
	onLayout : function(vw, vh) {
		if (Ext.type(vh) != 'number') { // handles grid's height:'auto' config
			return;
		}
		// note: this method is scoped to the GridView
		if (!this.grid.getGridEl().hasClass('x-grid-hide-gridsummary')) {
			// readjust gridview's height only if grid summary row is visible
			//2015-09-16 rem: (待处理)这里如果可以修改summary的height,列设置后第一次回显就不会有问题
			this.scroller.setHeight(vh - this.summary.getHeight());
		}
	},
	doWidth : function(col, w, tw) {
		var s = this.view.summary.dom;
		s.firstChild.style.width = tw;
		//s.firstChild.rows[0].childNodes[col].style.width = w;
		this.refreshSummary();	//2015-09-16 注释上一行,防止改变列宽时出现死循环, refresh,layout控制合计行显示
		this.view.layout();
	},
	doAllWidths : function(ws, tw) {
		var s = this.view.summary.dom, wlen = ws.length;
		s.firstChild.style.width = tw;
		var cells = s.firstChild.rows[0].childNodes;
		for (var j = 0; j < wlen; j++) {
			cells[j].style.width = ws[j];
		}
	},
	doHidden : function(col, hidden, tw) {
		var s = this.view.summary.dom,
			display = hidden ? 'none' : '';
		s.firstChild.style.width = tw;
		//s.firstChild.rows[0].childNodes[col].style.display = display;
		this.refreshSummary();	//2015-09-10 注释上一行, refresh,layout修改隐藏部分行后合计行显示不当的问题
		this.view.layout();
	},
	renderSummary : function(o, cs, cm) {
		cs = cs || this.view.getColumnData();
		var cfg = cm.config,
			buf = [],
			last = cs.length - 1;
		var summaryTitleColumn=1;
		for (var j = 1, len = cs.length; j < len; j++) {
			if(!cm.isHidden(j)){summaryTitleColumn=j;break}
		}
		var dsCount = this.grid.store.getCount();
		for (var i = 0, len = cs.length; i < len; i++) {
			var c = cs[i], cf = cm.getColumnById(c.id), p = {};
			p.id = c.id;
			p.style = c.style;
			if(cm.isHidden(cm.getIndexById(c.id))){
				continue;
			}
			if (cf.summaryType && dsCount > 0) {
				p.value =c.renderer(o.gridData[cf.dataIndex], p, o);
			} else {
				p.value = '';
			}
			if (p.value == undefined || p.value === ''){
				if(i==summaryTitleColumn){
					p.value = this.summaryTitle;
				}else{
					p.value = '';
				}
			}
			buf[buf.length] = this.cellTpl.apply(p);
		}
		cm.totalWidth=0;	//初始化cm.totalWidth的值 便于使用cm.getTotalWidth(false)  up:2015-3-5 徐超
		return this.rowTpl.apply({
			tstyle: 'width:' + cm.getTotalWidth(false) + ';',
			cells: buf.join('')
		});
	},
	refreshSummary : function() {
		if(!this.grid.rendered){
			return;
		}
		var g = this.grid, ds = g.store,
			cs = this.view.getColumnData(),
			cm = this.cm,
			rs = ds.getRange(),
			data = this.calculate(rs, cm),
			buf = this.renderSummary({gridData: data}, cs, cm);
		var gridWidth = this.getGridWidth();
		if (!this.view.summaryWrap) {
			this.view.summaryWrap = Ext.DomHelper.insertAfter(this.view.scroller, {
				tag: 'div',
				cls: 'x-grid3-gridsummary-row-inner'
			}, true);
		}
		this.view.summary = this.view.summaryWrap.update(buf).first();
		//var height=this.view.summary.getWidth()>gridWidth?35:20;
		var height=cm.getTotalWidth(false)>gridWidth?35:18;
		//IE11下有滚动条时,height>=38, 扩展websys.ext.3.3.0.css后,height>=44, 否则有竖向滚动条
		if(Ext.isIE11){height=height+3;}
		if(isInclude('websys.ext.3.3.0.css')){
			height = height + 6;
		}
		this.view.scroller.setStyle('overflow-x', 'hidden');
		this.view.summary.setStyle({'overflow-x':'auto','width':gridWidth,'height':height});// 解决滚动条滚动问题和页面刷新滚动条回到初始位置问题。
		this.view.summary.dom.scrollLeft = this.view.scroller.dom.scrollLeft;// 解决滚动条滚动问题和页面刷新滚动条回到初始位置问题。
		this.view.summary.on("scroll",function() {
			this.view.scroller.dom.scrollLeft = this.view.summary.dom.scrollLeft;
		},this);
	},
	// true to display summary row
	toggleSummary : function(visible) {
		var el = this.grid.getGridEl();
		if (el) {
			if (visible === undefined) {
				visible = el.hasClass('x-grid-hide-gridsummary');
			}
			el[visible ? 'removeClass' : 'addClass']('x-grid-hide-gridsummary');
			this.view.layout(); // readjust gridview height
		}
	},
	getSummaryNode : function() {
		return this.view.summary;
	},
	onWinResize:function(){
		//徐超2015-3-3 窗口大小发生变化时联动
		//var height=this.view.summary.getWidth()>document.body.clientWidth?35:20;
		//this.view.summary.setStyle({'overflow-x':'auto','width':document.body.clientWidth,'height':height});
		this.refreshSummary();
	},
	onLoad:function(){
		if(!this.grid.rendered){
			return;
		}
		var g = this.grid;
		var ds = g.store;
		var cs = this.view.getColumnData();
		var cm = this.cm;
		var gridWidth = this.getGridWidth();
		if(ds.reader.jsonData.summary){
			var rs = new ds.recordType(ds.reader.jsonData.summary);
		}else{
			return;
		}
		var rs=[].concat(rs);
		var data = this.calculate(rs, cm);
		var buf = this.renderSummary({gridData: data}, cs, cm);
		if (!this.view.summaryWrap) {
			this.view.summaryWrap = Ext.DomHelper.insertAfter(this.view.scroller, {
				tag: 'div',
				cls: 'x-grid3-gridsummary-row-inner'
			}, true);
		}
		this.view.summary = this.view.summaryWrap.update(buf).first();
		//var height=this.view.summary.getWidth()>gridWidth?35:20;
		var height=cm.getTotalWidth(false)>gridWidth?35:18;
		//IE11下有滚动条时,height>=38, 扩展websys.ext.3.3.0.css后,height>=44, 否则有竖向滚动条
		if(Ext.isIE11){height=height+3;}
		if(isInclude('websys.ext.3.3.0.css')){
			height = height + 6;
		}
		this.view.scroller.setStyle('overflow-x', 'hidden');
		//设置插件滚动条
		this.view.summary.setStyle({'overflow-x':'auto','width':gridWidth,'height':height});
		//插件滚动条拖动时的联动处理
		this.view.summary.dom.scrollLeft = this.view.scroller.dom.scrollLeft;
		this.view.summary.on("scroll",function() {
			this.view.scroller.dom.scrollLeft = this.view.summary.dom.scrollLeft;
		},this);
	},
	//IE8,9等版本,GridPanel.getWidth()获取的宽度考虑了超出显示区域的部分,故使用ownerCt
	getGridWidth : function(){
		var g = this.grid;
		return g.ownerCt ? g.ownerCt.getEl().getWidth() : g.getWidth();
	}
});

Ext.reg('gridsummary', Ext.ux.grid.GridSummary);
Ext.grid.GridSummary = Ext.ux.grid.GridSummary;

/*
 * all Calculation methods are called on each Record in the Store with the
 * following 5 parameters:
 * 
 * v - cell value record - reference to the current Record colName - column name
 * (i.e. the ColumnModel's dataIndex) data - the cumulative data for the current
 * column + summaryType up to the current Record rowIdx - current row index
 */
Ext.ux.grid.GridSummary.Calculations = {
	sum : function(v, record, colName, data, rowIdx) {
		return accAdd(data[colName], Ext.num(v, 0));
	},
	count : function(v, record, colName, data, rowIdx) {
		return rowIdx + 1;
	},
	max : function(v, record, colName, data, rowIdx) {
		return Math.max(Ext.num(v, 0), data[colName]);
	},
	min : function(v, record, colName, data, rowIdx) {
		return Math.min(Ext.num(v, 0), data[colName]);
	},
	average : function(v, record, colName, data, rowIdx) {
		var t = data[colName] + Ext.num(v, 0), count = record.store.getCount();
		return rowIdx == count - 1 ? (t / count) : t;
	}
}
