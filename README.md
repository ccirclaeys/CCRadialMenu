CCRadialMenu
============

    CCRadialMenuView *radialMenuView = [[CCRadialMenuView alloc] init];
    radialMenuView.dataSource = self;
    radialMenuView.delegate = self;
    radialMenuView.hidden = YES;
    radialMenuView.offset = 20;
    radialMenuView.shouldDisplayOnRadiusCollision = YES;
    [self.view addSubview:radialMenuView];
