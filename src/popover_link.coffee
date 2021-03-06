Ember.Widgets.PopoverLinkComponent = Ember.Component.extend
  classNames: ['popover-link']
  classNameBindings: ['disabled']
  placement:  'top'
  content:    null
  title:      null
  contentViewClass: null
  disabled:   no
  popoverClassNames: []
  rootElement: '.ember-application'
  fade: yes
  openOnLeftClick: true
  openOnRightClick: false
  hideOthers: false
  _popover: null

  willDestroyElement: ->
    @get('_popover')?.destroy()
    @_super()

  _contentViewClass: Ember.computed ->
    contentViewClass = @get 'contentViewClass'
    if typeof contentViewClass is 'string'
      return Ember.get contentViewClass
    contentViewClass
  .property 'contentViewClass'

  _openPopover: ->
    return if @get('disabled')

    popover = @get('_popover')

    if (popover?.get('_state') or popover?.get('state')) is 'inDOM'
      popover.hide()
    else
      if @get('hideOthers')
        Ember.Widgets.PopoverComponent.hideAll()

      popoverView = Ember.View.extend Ember.Widgets.PopoverMixin,
        layoutName: 'popover-link-popover'
        classNames: @get('popoverClassNames')
        controller: this
        targetElement: @get('element')
        container: @get('container')
        placement: Ember.computed.alias 'controller.placement'
        title:  Ember.computed.alias 'controller.title'
        contentViewClass: @get('_contentViewClass')
        fade: @get('fade')
      popover = popoverView.create()
      @set '_popover', popover
      popover.appendTo @get('rootElement')

  click: ->
    if not @get('openOnLeftClick')
      return false

    @_openPopover()
    return false

  contextMenu: ->
    if not @get('openOnRightClick')
      return false

    @_openPopover()
    return false

Ember.Handlebars.helper('popover-link-component', Ember.Widgets.PopoverLinkComponent)
