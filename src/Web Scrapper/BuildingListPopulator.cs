﻿using OpenQA.Selenium;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UoftTimetableGenerator.WebScrapper;

namespace Web_Scrapper
{
    class BuildingListPopulator
    {
        public void UpdateBuildingsInfo()
        {
            using (UofTDataContext db = new UofTDataContext())
            {
                db.Buildings.DeleteAllOnSubmit(db.Buildings);
                db.SubmitChanges();
            }
            InsertBuildingsList();
        }

        public void InsertBuildingsList()
        {
            Browser.Initialize();
            Browser.WebInstance.Url = "http://map.utoronto.ca/c/buildings";

            using (UofTDataContext db = new UofTDataContext())
            {
                IWebElement buildingsList = Browser.WebInstance.FindElement(By.ClassName("buildinglist"));
                IReadOnlyList<IWebElement> buildingElements = buildingsList.FindElements(By.TagName("li"));

                foreach (IWebElement building in buildingElements)
                {
                    string[] description = building.FindElement(By.XPath("./dl/dt")).Text.Split('|');
                    string address = building.FindElement(By.XPath("./dl/dd[1]")).Text.Trim();
                    string buildingName = description[0].Trim();
                    string buildingCode = description[1].Trim();

                    Building newBuilding = new Building
                    {
                        Address = address + " Toronto, Canada",
                        BuildingCode = buildingCode,
                        BuildingName = buildingName,
                        Latitude = null,
                        Longitude = null
                    };

                    db.Buildings.InsertOnSubmit(newBuilding);
                }
                db.SubmitChanges();
            }

            Browser.Close();
        }
    }
}
