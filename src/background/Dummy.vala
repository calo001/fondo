namespace Model {
    public Normal getDummyNormal() {
        return new Normal(
            12000, 
            "https://images5.alphacoders.com/117/thumb-1176495.jpg"
        );
    }

    public Slideshow getDummySlideshow() {
        var pic_files = new List<weak string> ();
        pic_files.append("https://images3.alphacoders.com/117/thumb-1176435.jpg");
        pic_files.append("https://images8.alphacoders.com/117/thumb-1176014.jpg");

        return new Slideshow(
            20000, 
            pic_files, 
            16000, 
            23000, 
            "https://images5.alphacoders.com/117/thumb-1175845.png"
        );
    }

    public DayNight getDummyDayNight () {
        var day_schedule = new List<int> ();
        var night_schedule = new List<int> ();

        day_schedule.append(1);
        day_schedule.append(2);
        day_schedule.append(3);
        day_schedule.append(4);
        day_schedule.append(5);

        night_schedule.append(6);
        night_schedule.append(7);
        night_schedule.append(8);
        night_schedule.append(9);
        night_schedule.append(10);

        return new DayNight(
            5000, 
            "https://images8.alphacoders.com/117/thumb-1175167.jpg", 
            "https://images.alphacoders.com/117/thumb-1175110.png", 
            day_schedule, 
            night_schedule
        );
    }

    public Config getDummyConfigNormal () {
        var normal = getDummyNormal ();
        return new Config(
            normal, 
            null, 
            null
        );
    }

    public Config getDummyConfigSlideshow () {
        var slideshow = getDummySlideshow ();
        return new Config(
            null, 
            slideshow, 
            null
        );
    }

    public Config getDummyConfigDayNight () {
        var dayNight = getDummyDayNight ();
        return new Config(
            null, 
            null, 
            dayNight
        );
    }
}