{
  enable = true;
  backup.enable = true;
  scheduler = {
    enable = true;
    schedule =
      [{
        description = "Weekly action list";
        template = "reviews/weekly-actions.smos.template";
        destination = "projects/weekly-actions.smos";
        schedule = "0 1 * * 6"; # Cron schedule: 3am (UTC-time) on Saturday
      }
        {
          description = "Morning routine";
          template = "reviews/daily.smos.template";
          destination = "projects/daily.smos";
          schedule = "0 1 * * 0-6"; # Cron schedule: "At 3am (UTC-time) every day"
        }
        {
          description = "Sunday relaxation";
          template = "reviews/sunday.smos.template";
          destination = "projects/sunday.smos";
          schedule = "0 1 * * 0"; # Cron schedule: "3am (UTC-time) Sunday"
        }
        {
          description = "Weekly review";
          template = "reviews/weekly-review.smos.template";
          destination = "projects/weekly-review.smos";
          schedule = "0 1 * * 6"; # Cron schedule: "3am (UTC-time) Saturday"
        }
        {
          description = "Monthly review";
          template = "reviews/monthly-review.smos.template";
          destination = "projects/monthly-review.smos";
          schedule = "0 0 1 * *";
        }
        {
          description = "Quarterly review";
          template = "reviews/quarterly-review.smos.template";
          destination = "projects/quarterly-review.smos";
          schedule = "0 0 1 */3 *"; # Cron schedule: Quarterly
        }
        {
          description = "Yearly review";
          template = "reviews/yearly-review.smos.template";
          destination = "projects/yearly-review.smos";
          schedule = "0 0 1 1 *"; # Cron schedule: January 1 at midnight
        }];
  };
  calendar.sources = [
    {
      name = "Personal gmail";
      source = "https://calendar.google.com/calendar/ical/vandenbroeck%40cs-vdb.com/private-5b07dcbdc5ccd526510a3a2fa999f05b/basic.ics";
      destination = "projects/calendar.smos";
    }
    {
      name = "Platonic Systems";
      source = "https://calendar.google.com/calendar/ical/nick.van.den.broeck%40platonic.systems/public/basic.ics";
      # Find the secret address in iCal format, see gmail docs
      destination = "projects/ardana/calendar.smos";
    }
  ];
  config = {
    work.checks = [ "ancestor:property:goal" ];
    waiting.threshold = "2d";
    explainer-mode = false;
  };
}
