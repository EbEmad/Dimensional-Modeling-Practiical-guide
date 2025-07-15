#### Fact Granularity
The **grain** is the definition of what a single row in the **fact table** will represent or contains.
**Grain** describes the physical event which needs to be measured.
- Grain controls the dimensions which are available in fact.
- Grain represents the level of information we need to represent.
- It is not always time, could be events Etc.
- Start from the lowest possible grain (**Lowest level**)hourly, daily --> weekly --> monthly
	- note that from hourly, to daily or monthly will be better than implementing them from the transaction 
	- Hourly is the most difficult

---

### Fact Types

- [Additive facts](../Additive%20facts/)
- [Semi-additive facts](../Semi-additive%20facts/)
- [Non-additive facts](../Non-additive%20facts/)
- [Derived facts](../Derived%20facts/)
- [Textual facts](../Textual%20facts/)
- [Fact-less fact](../Fact-less%20fact/)