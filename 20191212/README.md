# Security Data Analytics Workshop

Refer to [Meetup page](https://www.meetup.com/redteamproject/events/266637708/) for details.

## Artifacts

* [Tonight's slides](./slides.pdf)
* [Neo4j Desktop download page](https://neo4j.com/download/)
* [sckg github](https://github.com/redteam-project/sckg)
* [neo4j.yml](https://gist.github.com/jason-callaway/32ff25017bee2735b8daf3967cb1a013)
* [meetup.tsv](https://gist.github.com/jason-callaway/bd1bfcefc693f770b1463e87742844aa)
* [private.yml](https://gist.github.com/jason-callaway/ed5b74c895d6fdd87c3f49ce05349421)

### Queries

#### Slide 11

```
call db.schema()
```

#### Slide 12

```
match (r:regime {name: 'NIST 800-53'})-[:HAS]->(f:family) return r, f
```

#### Slide 13

```
match (r:regime {name: 'NIST 800-53'})-[:HAS]->(f:family) return r.name, f.name
```

#### Slide 14

```
match (r:regime {name: 'NIST 800-53'})-[:HAS]->(f:family) 
with r, f 
match (f)-[:HAS]->(c:control) return r, f, c
```

#### Slide 15

```
match (r:regime {name: 'NIST 800-53'})-[:HAS*]->(f:family) 
with r, f 
match (f)-[:HAS]->(c:control) return r, f, c
```

#### Slide 17

```
match (r:regime) return r
```

#### Slide 18

```
match (:regime {name: 'NIST CSF'})-[:HAS*]-(csf:baseline)
with csf
match (:regime {name: 'NIST 800-53'})-[:HAS*]->(nist:control)
with csf, nist
match (:regime {name: 'PCI DSS'})-[:HAS*]->(pci:control)
with csf, nist, pci
match (csf)-[:REQUIRES]->(nist), (csf)-[:REQUIRES]->(pci)
return nist.name as NIST, pci.name as PCI order by PCI
```

#### Slide 19

```
match (:regime {name: 'FedRAMP'})-[:HAS]->(fedramp:baseline {name: 'High'})
with fedramp
match (:regime {name: 'NIST CSF'})-[:HAS*]-(csf:baseline)
with fedramp, csf
match (:regime {name: 'NIST 800-53'})-[:HAS*]->(nist:control)
with fedramp, csf, nist
match (:regime {name: 'PCI DSS'})-[:HAS*]->(pci:control)
with fedramp, csf, nist, pci
match (fedramp)-[:REQUIRES]->(nist), (csf)-[:REQUIRES]->(nist), (csf)-[:REQUIRES]->(pci)
return nist.name as FedRAMP_High, pci.name as PCI order by PCI
```

#### Slide 25

```
match (:regime {name: 'meetup'})-[:HAS]->(meetup:baseline {name: 'meetup baseline'})
with meetup
match (:regime {name: 'NIST CSF'})-[:HAS*]-(csf:baseline)
with meetup, csf
match (:regime {name: 'NIST 800-53'})-[:HAS*]->(nist:control)
with meetup, csf, nist
match (:regime {name: 'PCI DSS'})-[:HAS*]->(pci:control)
with meetup, csf, nist, pci
match (meetup)-[:REQUIRES]->(nist), (csf)-[:REQUIRES]->(nist), (csf)-[:REQUIRES]->(pci)
return nist.name as Meetup, pci.name as PCI order by PCI
```


